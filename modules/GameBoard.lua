local act = require '/modules/actor'
local t   = require '/modules/table'
local Label = require '/modules/Label'

local BROUND    = 10
local LINEWIDTH = 3
local FONTSIZE  = 40
local COLORS    = {
    {186,225,255},
    {186,255,201},
    {255,255,186},
    {255,223,186},
    {255,179,186},
}
local BOARDDIM = {
    300, -- x0
    100,  -- y0
    300, -- width
    950, -- height
}
local TITLEDIM = {
    400, -- x0
    60,  -- y0
    nil, -- color
    200 -- width
}

local ARROWSCALE = {
    0.3, -- sx
    0.38 -- sy
}

local GameBoard = {}
GameBoard.__index = GameBoard

-- Helpers
local function getBlockIdx(self, y)
    y = y - self.y
    return math.ceil(y / self.blockh)
end

local function drawGlow(x,y,w,h)
    local color = {255, 255, 255}

    love.graphics.setColor(color)
    love.graphics.setLineWidth(LINEWIDTH)
    love.graphics.rectangle('line', x, y, w, h, BROUND)
end

local function darken(color, factor)
    factor = factor or 0.8
    return t.map(function(v)
                    return v * factor
                end, color)
end
--
function GameBoard:new(x,y,w,h)
    local board    = act.new( unpack(BOARDDIM) )
    setmetatable(board, GameBoard)

    board.currpos  = {}
    board.blockh   = 0
    board.selected = nil
    board.solvedcb = function() end
    board.font     = love.graphics.newFont( "/assets/fonts/Montserrat/Montserrat-SemiBold.ttf"
                                          , FONTSIZE
                                          )

    board.arrow    = love.graphics.newImage( "/assets/images/arrow.png")


    -- Title label
    local titlefont = love.graphics.newFont( "/assets/fonts/Montserrat/Montserrat-BlackItalic.ttf"
                                      , FONTSIZE -- size
                                      )
    self.titlelbl = Label:new( unpack(TITLEDIM) )
    self.titlelbl:setFont(titlefont)

    return board
end

function GameBoard:check()
    -- Checks if the board has a correct ordering
    local solved = t.equals(self.currpos, t.range(self.nblocks))
    return solved
end

function GameBoard:setBlocks(sblocks)
    self.blocks  = sblocks.blocks
    self.nblocks = sblocks.nblocks
    self.blockh  = self.h / self.nblocks
    self.color   = COLORS[math.random(#COLORS)] -- varies for higher dificulties
    self.titlelbl:setText(sblocks.title)
end

function GameBoard:shuffle()
    t.shuffleM(board.currpos)
end

function GameBoard:init()
    self.solved  = false
    self.currpos = t.shuffle(t.range(self.nblocks))
end

function GameBoard:release(x, y)
    if not act.detect(self, x, y) then
        self.preselected = nil
        self.selected = nil
        return
    end

    local idx = getBlockIdx(self, y)

    if not self.selected then
        self.selected = self.preselected == idx and idx or nil
    else
        t.swap(self.currpos, idx, self.selected)
        -- if testForWin() then onSolveBoard() end
        self.selected = nil -- reset saved idx
    end
    self.preselected = nil
end

function GameBoard:press(x, y)
    if act.detect(self, x, y) then
        local idx = getBlockIdx(self, y)
        self.preselected = idx
    end
end

function GameBoard:draw()
    self.titlelbl:draw(nil,'center')
    -- Draws the board (duh)
    local indices = self.currpos
    local blocks  = self.blocks
    local blocky, blockx  = self.y, self.x

    -- Draw blocks
    for idx,i in ipairs(indices) do
        -- draw every block
        local color = self.color

        if self.preselected == idx then
            -- Show it is preselected by making it appear darker
            color = darken(color)
        end

        love.graphics.setColor(color)
        love.graphics.rectangle( 'fill'
                               , blockx
                               , blocky
                               , self.w
                               , self.blockh
                               , BROUND
                               )

        if self.selected and self.selected == idx then
            -- if block is selected...
            drawGlow(blockx, blocky, self.w, self.blockh, true)
        end

        blocky = blocky + self.blockh + 1
    end

    -- Draw decorative arrow
    love.graphics.setColor(255,255,255, 64)
    love.graphics.draw( self.arrow
                      , self.x -- x
                      , self.y -- y
                      , 0  -- r
                      , 0.63 -- sx
                      , 0.95 -- sy
                      , -10  -- ox
                      , 0
                      )

    -- Draw labels
    blocky, blockx  = self.y, self.x
    for idx,i in ipairs(indices) do
        love.graphics.setFont(self.font)
        love.graphics.setColor(0,0,0)
        love.graphics.printf( blocks[i]
                            , blockx + 10
                            , blocky + 30
                            , self.w - 20
                            , "center"
                            )
        blocky = blocky + self.blockh + 1
    end
end

function GameBoard:setSolveCb(cb)
    self.solvecb = cb
end

return GameBoard
