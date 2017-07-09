-- Modules
local t            = require "/modules/table"
local Button       = require "/modules/Button"
local act          = require "/modules/actor"
local GameBoard    = require "/modules/GameBoard"
local InputManager = require "/modules/InputManager"
local Timer        = require "/modules/Timer"

local bgtimer      = 0

local BGCOLORS     = {
    correct   = {0,106,78},
    incorrect = {106,0,28},
    neutral   = {0,81,106}
}

--[[
    Idea de tipos de bloque:
        - Bloques de números
        - Bloques de colores
        - Bloques de letras
        - Bloques musicales?
        - Bloques historicos?
]]

function onMistake()
    timer:deduct(5)
    setBgTo('incorrect')
end

function onVictory()
    timer:pause()
    setBgTo('correct', 1/0)
end

function setBgTo(s, time)
    bgtimer = time or 1
    bgcolor = BGCOLORS[s]
end

function love.load(arg)
    math.randomseed(os.time())

    bgcolor = BGCOLORS.neutral

    -- input manager
    inputmgr = InputManager:new()
    inputmgr:setSwipe('down', function(x0, y0, x, y)
                                if gameboard:check() then onVictory()
                                else onMistake() end
                              end)

    -- Hint button
    local image = love.graphics.newImage("/assets/images/ui/hint.png")

    hintbtn = Button:new( 60 -- x0
                        , 700 -- y0
                        )
    hintbtn:setImage(image)
    hintbtn:setRelease(function()
                        print("RELEASED")
                    end)

    -- gameboard
    gameboard = GameBoard:new()
    gameboard:setBlocks(require "boards/test")
    gameboard:init()

    -- timelbl
    local timefont = love.graphics.newFont( "/assets/fonts/Boogaloo/Boogaloo-Regular.ttf"
                                      , 156 -- size
                                      )
    timer = Timer:new( 100 -- y0
                     , 60 -- x0
                     )
    timer:setFont(timefont)
    timer:setAlarm(function()
                    setBgTo('incorrect', 1/0)
                    print("LOST")
                   end)

    timer:run()
end

function love.draw()
    love.graphics.setBackgroundColor(bgcolor) -- This will change if a mistake was made
    timer:draw()
    hintbtn:draw()
    gameboard:draw()
end

function love.update(dt)
    timer:update(dt)

    if bgtimer < 0 then
        bgcolor = BGCOLORS.neutral
    else
        bgtimer = bgtimer - dt
    end
end

function love.mousepressed(x, y, button)
    inputmgr:press(x, y)
    gameboard:press(x,y)
end

function love.mousereleased(x, y, button, isTouch)
    gameboard:release(x, y)
    --hintbtn:release(x, y)
    inputmgr:release(x, y)
end
