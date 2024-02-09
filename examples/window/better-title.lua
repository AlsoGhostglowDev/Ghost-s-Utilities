local window = require "ghostutil.Window"

-- local defaultTitle = "Friday Night Funkin': Psych Engine // Ghost's Utilities"
local defaultTitle = "Friday Night Funkin': Psych Engine"
local divider1 = " // "
local divider2 = " | "
local started = false

function onCreatePost()
    luaDebugMode = true
    window.changeTitle(".                                                                                                                                "..defaultTitle.." | "..songName)
end

function onDestroy()
    window.changeTitle(defaultTitle)
end

function onSongStart()
    started = true
end

function onCountdownTick(counter)
    if counter == 0 then
        window.changeTitle(".                                                                                                                                                                              >    Three...    <");
    elseif counter == 1 then
        window.changeTitle(".                                                                                                                                                                               >   Two..   <");
    elseif counter == 2 then
        window.changeTitle(".                                                                                                                                                                                >  One,  <");
    elseif counter == 3 then
        window.changeTitle(".                                                                                                                                                                                 > GO! <");
    end
end

function onUpdate(elapsed)
    if started then
        window.changeTitle(".                                                                                                                                "..defaultTitle..divider1..songName.." ["..difficultyName.."] (" .. formatTime(getSongPosition() - noteOffset) .. " / " .. formatTime(songLength) .. ")")
    end
end

function onPause(elapsed)
    window.changeTitle(".                                                                                                                                "..defaultTitle..divider1..songName.." ["..difficultyName.."] (Paused)")
end

function formatTime(millisecond) -- thanks moonlight :D
	local seconds = math.floor(millisecond / 1000)

	return string.format("%01d:%02d", (seconds / 60) % 60, seconds % 60)
end
