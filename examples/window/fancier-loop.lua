--[[
                         -- DISCLAIMER --

        THE SCRIPT WILL MOSTLY *ONLY* WILL WORK ON VANILLA
        WEEKS LIKE:

        DADDY DEAREST's
        PICO's
        'and some others we didn't test~'
]]

-- Requires
local window = require "ghostutil.Window"

-- Variables
local started = false

-- EDITABLE VARIABLES
local num = 0.4
local distance = 0 -- this is need to be editable on the onUpdatePost function
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
    num = num + elapsed

    -- Another editable variables
    local windowOffsets = {
        x = 300,
        y = 150
    }

    local hudOffsets = {
        x = 0,
        y = 0
    }

    local cameraOffsets = {
        x = 700,
        y = 450
    }

    -- The main code, I guess
    distance = 50
    setProperty("camFollowPos.x", (math.sin(num * speed.x) * distance) + cameraOffsets.x)
    setProperty("camFollowPos.y", (math.sin(num * speed.y) * distance) + cameraOffsets.y)

    distance = 20
    setProperty("camHUD.x", (math.sin(num * speed.x) * distance) + hudOffsets.x)
    setProperty("camHUD.y", (math.sin(num * speed.y) * distance) + hudOffsets.y)

    distance = 50
    window.setProperty("x", (math.sin(num * speed.x) * distance) + windowOffsets.x)
    window.setProperty("y", (math.sin(num * speed.y) * distance) + windowOffsets.y)
end

function onDestroy()
    -- Centers the window when you're done with the song. (When exit, restarting, going to debug, dying, etc.) 
    window.screenCenter()
end