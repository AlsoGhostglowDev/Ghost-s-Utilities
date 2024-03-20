---@meta modcharts
---@author GhostglowDev

---@class Modcharts
local modchart = {}

local u = require "ghostutil.util"
local d = require "ghostutil.debug"

---Transitions to their respective downscroll positions
---@param note integer 0-3 is the opponent's and 4-7 is the player's 
---@param toggle boolean Downscroll (Reminder: Toggling this whilst on downscroll will make it upscroll.)
---@param duration number Time it takes to complete
---@param ease string FlxEase
---@param withUi boolean Do you want the UI to be in their own "scroll" position?
---@param modchartTag string The tag for the `onTweenCompleted()` function (If empty: ModchartDownscroll<Note>, e.g. "ModchartDownscroll3")
function modchart.downscroll(note, toggle, duration, ease, withUi, modchartTag)
    toggle = u.toBool(toggle)
    if not u.isBool(toggle) then d.error("modchart.downscroll:2: Expected a boolean") end 

    local strum = ((note <= 3) and "opponentStrums" or "playerStrums")
    noteTweenY((((toggle and "ModchartDownscroll" or "ModchartUpscroll")..note)), note, _G['default'.. (note <= 3 and 'Opponent' or 'Player') ..'StrumY'.. (note%4)] + (toggle and (withUi and (downscroll and -510 or 510) or (downscroll and -470 or 470)) or 0), (duration or 1), ease)

    setPropertyFromGroup(strum, (note%4), "downScroll", (toggle and (not downscroll)) or ((not toggle) and downscroll))

    for i = 0, getProperty("notes.length") do
        if getPropertyFromGroup("notes", i, "isSustainNote") and (getPropertyFromGroup("notes", i, "noteData") == (note%4)) then
            local mustPress = getPropertyFromGroup("notes", i, "mustPress")
            if ((note > 3 and mustPress) or (note < 4 and not mustPress)) then
                setPropertyFromGroup("notes", i, "flipY", (toggle and (not downscroll)) or ((not toggle) and downscroll))
            end
        end
    end

    for i = 0, getProperty("unspawnNotes.length")-1 do
        if getPropertyFromGroup("unspawnNotes", i, "isSustainNote") and (getPropertyFromGroup("unspawnNotes", i, "noteData") == (note%4)) then
            local mustPress = getPropertyFromGroup("unspawnNotes", i, "mustPress")
            if ((note > 3 and mustPress) or (note < 4 and not mustPress)) then
                setPropertyFromGroup("unspawnNotes", i, "flipY", (toggle and (not downscroll)) or ((not toggle) and downscroll))
            end
        end
    end

    if withUi then
        -- thanks to laztrix for optimizing this
        local objects = {
            timeTxt = {19, 676},
            timeBar = {31.25, 688.25},
            timeBarBG = {27.25, 684.25},
            healthBar = {644.8, 83.2},
            healthBarBG = {640.8, 79.2},
            scoreTxt = {676.8, 115.2},
            iconP1 = {569.8, 8.2},
            iconP2 = {569.8, 8.2}
        }
        
        local toggleValue = (toggle and downscroll) and 1 or 2
        
        for name, pos in pairs(objects) do
            if (version >= '0.7.0') and (name == 'timeBarBG' or name == 'healthBarBG') then 
                goto continue
            end
            doTweenY(("ModchartDownscrollUi_"..name), name, pos[toggleValue], duration or 1, ease)
            ::continue::
        end
    end
    runHaxeCode("game.callOnLuas('onModchart', ['"..(modchartTag or ("ModchartDownscroll"..note)).."']);")
end

---Transitions to middlescroll
---@param toggle boolean Middlescroll or nah?
---@param duration number The time it takes to complete
---@param opponentVisible boolean Do you want the opponent's strum to be visible?
---@param ease string FlxEase
---@param modchartTag string Tag for the function `onTweenCompleted()` - (If empty: ModchartMiddlescroll)
function modchart.middlescroll(toggle, opponentVisible, duration, ease, modchartTag)
    toggle = u.toBool(toggle)
    if not u.isBool(toggle) then d.error("modchart.middlescroll:1: Expected a boolean") end
    local midPos = {dad = {82, 194, 971, 1083}, bf = {412, 524, 636, 748}}
    local doTween = (opponentVisible and noteTweenX or noteTweenAlpha)
    for i = 0,3 do
        doTween(((toggle and "ModchartMiddlescrollDad" or "ModchartUnMiddlescrollDad"))..i, i, (toggle and (opponentVisible and midPos.dad[(i+1)] or 0) or (opponentVisible and _G['defaultOpponentStrumX'.. (i%4)] or 1)), (duration or 1), ease)
        noteTweenX(((toggle and "ModchartMiddlescrollBf" or "ModchartUnMiddlescrollBf"))..i, (i+4), (toggle and midPos.bf[(i+1)] or _G['defaultPlayerStrumX'.. (i%4)]), (duration or 1), ease)
    end
    runHaxeCode("game.callOnLuas('onModchart', ['"..(modchartTag or ("ModchartMiddlescroll")).."']);")
end

---Swaps the opponent's strums with the player's
---@param swap boolean Self-explanatory
---@param duration number The time it takes for it to complete
---@param ease string FlxEase
---@param modchartTag string Tag for the function `onTweenCompleted()` (If empty: ModchartSwapStrums)
function modchart.swapStrums(swap, duration, ease, modchartTag)
    swap = u.toBool(swap)
    if not u.isBool(swap) then d.error("modchart.swapStrums:1: Expected a boolean") end
    local notes = {x = {defaultOpponentStrumX0,defaultOpponentStrumX1,defaultOpponentStrumX2,defaultOpponentStrumX3,defaultPlayerStrumX0,defaultPlayerStrumX1,defaultPlayerStrumX2,defaultPlayerStrumX3}}
    for i = 0,7 do
        noteTweenX(((swap and ("ModchartSwapStrums") or ("ModchartUnSwapStrums")))..i, i, ((i <= 3) and (swap and notes.x[i+5] or notes.x[i+1]) or (swap and notes.x[(i+1)-4] or notes.x[(i+5)-4])), (duration or 1), ease)
    end
    runHaxeCode("game.callOnLuas('onModchart', ['"..(modchartTag or ("ModchartSwapStrums")).."']);")
end

return modchart