local act = require '/modules/actor'
local Label = require '/modules/Label'

local Timer = {}
Timer.__index = Timer

function Timer:new(x, y, initial, fsize, color)
    local timer = act.new(x, y)
    setmetatable(timer, Timer)

    timer.label   = Label:new(x, y, fsize, color)

    timer.start   = initial or 20
    timer.current = timer.start
    timer.running = false
    timer.alarm   = function() end

    return timer
end

function Timer:setFont(font)
    self.label:setFont(font)
end

function Timer:draw()
    local t = math.abs(math.ceil(self.current))
    self.label:draw(t)
end

function Timer:reset()
    self.current = self.start
end

function Timer:update(dt)
    if not self.running then return end

    self.current = self.current - dt

    if self.current <= 0 then
        self.alarm()
        self.running = false
        self.current = 0
    end
end

function Timer:setAlarm(cb)
    self.alarm = cb
end

function Timer:run()
    self.running = true
    self:reset()
end

function Timer:deduct(n)
    self.current = self.current - n
end

function Timer:pause()
    self.running = false
end

function Timer:resume()
    self.running = true
end

return Timer
