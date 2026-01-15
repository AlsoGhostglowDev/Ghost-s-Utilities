luaDebugMode = true

--[[
    GHOSTUTIL's CALLBACK HANDLER
    
    This script is meant to handle GhostUtil's modules' callbacks.
    The "require" function cancels GhostUtil's Psych Callbacks, so with this script,
    we can call multiple module's callbacks without issues. 
]]

local hasPre = version > '0.7.2' 
local callbacks = {
    -- Psych Engine callbacks
    {'onCreate', 0, true}, {'onUpdate', 1, true},
    {'onStartCountdown'},  {'onCountdownStarted'}, {'onCountdownTick', 1},
    {'onMoveCamera', 1}, 
    {'onStartCountdown'},  {'onCountdownStarted'}, {'onCountdownTick', 1}, 
    {'onSectionHit'},      {'onBeatHit'},          {'onStepHit'},
    {'onSongStart'},       {'onEndSong'},
    {'onDestroy'},

    {'onSpawnNote', 5},
    {'goodNoteHit', 4, false, hasPre},      {'opponentNoteHit', 4, false, hasPre}, {'onUpdateScore', 1, false, true}, 
    {'noteMiss', 4}, {'noteMissPress', 1}, {'onGhostTap', 1},
    {'preUpdateScore', 1}, {'onRecalculateRating'},
    
    {'onPause'},    {'onResume'},
    {'onGameOver'}, {'onGameOverStart'}, {'onGameOverConfirm', 1},

    {'onEvent', 4}, {'onEventPushed', 4},
    {'onTweenCompleted', 2}, {'onTimerCompleted', 3}, {'onSoundFinished', 1},

    {'onKeyPress', 1, false, hasPre},      {'onKeyRelease', 1, false, hasPre}, 

    -- GhostUtil callbacks
    {'onNumberTween', 2}
}
local modules = {'helper', 'util', 'modchart', 'window'}

local function arg(amount)
    if amount <= 0 then return ' ' end
    local letters, ret = stringSplit('abcdefghijklmnopqrstuvwxyz', ''), '' 
    for i = 1, amount do
        ret = ret .. letters[i] .. (i == amount and '' or ',')
    end

    return ret
end

local function getCalls(callback, a)
    local ret = ''
    for i, m in ipairs(modules) do
        ret = ret .. 'callOnLuas("gcall_'.. m ..'", {"'.. callback ..'", {'.. a ..'}})' .. (i == #modules and '' or ' ; ')
    end

    return ret
end

local call = ''
for _, _c in ipairs(callbacks) do
    local c, pc, hasPost, hasPre = _c[1], _c[2] or 0, (_c[3] == nil and false or _c[3]), (_c[4] == nil and false or _c[4])
    for i = 1, ((hasPost or hasPre) and 2 or 1) do
        local c = c ..(i == 2 and (hasPost and 'Post' or 'Pre') or '')
        call = call .. (c == 'onCreate' and [[
            ]].. getCalls(c, arg(pc)) or [[
            function ]].. c ..[[(]].. arg(pc) ..[[)
                ]].. getCalls(c, arg(pc)) ..[[
            end
        ]])
    end
end

local loadCode = load or loadstring
loadCode(call)()