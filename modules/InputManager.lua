InputManager = {}
InputManager.__index = InputManager

local THRESHOLD   = 40   -- precision for "straight" movements
local SWIPE_SPEED = 300 -- minimum speed for swipe movements

function InputManager:new()
    local imgr = {}
    setmetatable(imgr, InputManager)

    imgr.x0 = nil
    imgr.y0 = nil
    imgr.t0 = nil

    imgr.gestures = {
        tap    = function(x,y) end,
        pan    = function(x0, y0, x, y) end,
        swipel = function(x0, y0, x, y) end, -- swipe left
        swiper = function(x0, y0, x, y) end, -- swipe right
        swipeu = function(x0, y0, x, y) end, -- swipe up
        swiped = function(x0, y0, x, y) end, -- swipe down
    }

    return imgr
end

function InputManager:press(x, y)
    self.x0 = x
    self.y0 = y
    self.t0 = love.timer.getTime()
end

function InputManager:setSwipe(direction, cb)
    if direction == 'left' then
        self.gestures.swipel = cb
    elseif direction == 'right' then
        self.gestures.swiper = cb
    elseif direction == 'up' then
        self.gestures.swipeu = cb
    elseif direction == 'down' then
        self.gestures.swiped = cb
    end
end

function InputManager:setTap(cb)
    self.gestures.tap = cb
end

local function selectGesture(deltax, deltay, deltat)
    print(deltax, deltay, deltat)

    if math.abs(deltax) < THRESHOLD and math.abs(deltay) < THRESHOLD then
        -- no movement (tap)
        return 'tap'
    end

    if math.abs(deltax) < THRESHOLD then
        -- vertical movement
        local speed = deltay / deltat
        if speed > SWIPE_SPEED then
            -- swipe down
            return 'swiped'
        elseif speed > SWIPE_SPEED then
            -- swipe up
            return 'swipeu'
        end
    else
        -- horizontal movement
        local speed = deltax / deltat
        if speed > SWIPE_SPEED then
            -- swipe right
            return 'swiper'
        elseif speed > SWIPE_SPEED then
            -- swipe left
            return 'swipel'
        end
    end

    return 'pan'
end

function InputManager:release(x, y)
    local deltax = x - self.x0
    local deltay = y - self.y0
    local deltat = love.timer.getTime() - self.t0

    local gesture = selectGesture(deltax, deltay, deltat)

    self.gestures[gesture](self.x0, self.y0, x, y)
end

return InputManager
