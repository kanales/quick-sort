local act = {}

function act.new(x,y,w,h)
    x = x or 0
    y = y or 0
    w = w or 0
    h = h or 0

    return {
        x = x,
        y = y,
        w = w,
        h = h,
    }
end

function act.detect(self, x, y)
    local x0, y0 = self.x, self.y

    return x > x0 and x < x0 + self.w
            and y > y0 and y < y0 + self.h
end

return act
