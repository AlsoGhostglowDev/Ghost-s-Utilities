-- WHAT THE FUCK!!!!!!!!!!!!!!!!!!!!!!
function onCreate() luaDebugMode = true end

local callClasses = {
    'debug', 'game',
    'media', 'window'
}

local function _c(args)
    for _, class in ipairs(callClasses) do
        callOnLuas('__'.. class ..'_gcall', args)
    end
end

function onCreatePost() _c({'createpost', {}}) end
function onCountdownTick(c) _c({'counttick', {c}}) end
function noteMiss(id, d, t, s) _c({'bfmiss', {id, d, t, s}}) end
function goodNoteHit(id, d, t, s) _c({"bfhit", {id, d, t, s}}) end
function opponentNoteHit(id, d, t, s) _c({"dadhit", {id, d, t, s}}) end
function onBeatHit() _c({"beathit", {}}) end
function onStepHit() _c({"stephit", {}}) end
function onUpdatePost(el) _c({"updatepost", {dt = el}}) end
function onDestroy() _c({"destroy", {}}) end