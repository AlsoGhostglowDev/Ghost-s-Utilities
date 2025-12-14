luaDebugMode = true

local callbacks = {
    {'onCreate', 0, true}, {'onUpdate', 1, true},
    {'goodNoteHit', 4},    {'opponentNoteHit', 4},
    {'noteMiss', 4},       {'onGhostTap', 1},
    {'onStartCountdown'},  {'onCountdownStarted'}, {'onCountdownTick', 1},   
    {'onSectionHit'},      {'onBeatHit'},          {'onStepHit'},
    {'onSongStart'},       {'onEndSong'},
    {'onDestroy'}
}
local modules = {'util', 'modchart'}

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
        call = call .. [[
            function ]].. c ..[[(]].. arg(pc) ..[[)
                ]].. getCalls(c, arg(pc)) ..[[
            end
        ]]
    end
end

local loadCode = load or loadstring
loadCode(call)()