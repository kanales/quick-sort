local act = require "/modules/actor"

local Button = {}
Button.__index = Button

function Button:new(x,y)
    local act = act.new(x,y)
    setmetatable(act, Button)

    act.images  = {}
    act.ispressed = false
    act.releasecb = function() end
    act.presscb   = function() end

    return act
end

function Button:setImage(image, mode)
    if mode then
        self.images[mode] = love.image
    else
        self.images.default = image
    end

    self.h, self.w = image:getHeight(), image:getWidth()
end

function Button:draw(mode)
    local img
    if not mode then
        img = self.images.default
    else
        img = self.images[mode]
    end

    love.graphics.draw( img
                      , self.x
                      , self.y
                      )
end

function Button:setPos(x, y)
    self.x, self.y = x, y
end

function Button:setRelease(cb)
    self.releasecb = cb
end

function Button:setPress(self, cb)
    self.presscb = cb
end

function Button:setDefault(self, cb)
    self.defaultcb = cb
end

function Button:press(x, y)
    if act.detect(self, x,y) then
        self.presscb()
        self.ispressed = true
    end
end

function Button:release(x, y)
    if not self.ispressed then return end

    if act.detect(self, x,y) then
        self.releasecb()
    else
        self.defaultcb()
    end
end

return Button
