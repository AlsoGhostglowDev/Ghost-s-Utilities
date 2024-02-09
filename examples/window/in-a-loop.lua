-- Requires
local window = require "ghostutil.Window"

-- Variables
local started = false

-- EDITABLE VARIABLES
local num = 0.4
local distance = 80
local speed = {
    x = 1,
    y = 2,
}

function onCreatePost()
    -- This simply just adds "lime.app.Application" library to the hscript stuffs
    window.init()

    -- Easy to know when you get an error.
    luaDebugMode = true
end

function onSongStart()
    started = true
end

function onUpdatePost(elapsed)
    if started then
        -- The code for the looping motion
        num = num + elapsed
        local offset = {
            x = 300,
            y = 150
        }
        window.setProperty("x", (math.sin(num * speed.x) * distance) + offset.x)
        window.setProperty("y", (math.sin(num * speed.y) * distance) + offset.y)
    end
end

function onDestroy()
    -- Centers the window when you're done with the song. (When exit, restarting, going to debug, dying, etc.) 
    window.screenCenter()
end