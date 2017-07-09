local act = require "/modules/actor"

local Label = {}
Label.__index = Label

function Label:new(x,y, color, w)
    local act = act.new(x, y)
    setmetatable(act, Label)

    act.w     = w or 200
    act.text  = text or ''
    act.fsize = 12
    act.font  = nil
    act.color = color or {255, 255, 255}

    return act
end

function Label:setFont(font)
    self.font = font
end

function Label:draw(text, format)
    local text = text or self.text

    love.graphics.setFont(self.font)
    love.graphics.setColor(unpack(self.color))
    love.graphics.printf(text
                        , self.y -- x
                        , self.x -- y
                        , self.w
                        , format
                        )
end

function Label:setPos(x, y)
    self.x, self.y = x, y
end

function Label:setText(text)
    self.text = text
end

return Label
