local keyboard = {}

local helper = require 'ghostutil.backend.helper'
local outdate = require 'ghostutil.outdate-handler'

-- key indices
keyboard.ANY = -2
keyboard.NONE = -1
keyboard.A = 65
keyboard.B = 66
keyboard.C = 67
keyboard.D = 68
keyboard.E = 69
keyboard.F = 70
keyboard.G = 71
keyboard.H = 72
keyboard.I = 73
keyboard.J = 74
keyboard.K = 75
keyboard.L = 76
keyboard.M = 77
keyboard.N = 78
keyboard.O = 79
keyboard.P = 80
keyboard.Q = 81
keyboard.R = 82
keyboard.S = 83
keyboard.T = 84
keyboard.U = 85
keyboard.V = 86
keyboard.W = 87
keyboard.X = 88
keyboard.Y = 89
keyboard.Z = 90
keyboard.ZERO = 48
keyboard.ONE = 49
keyboard.TWO = 50
keyboard.THREE = 51
keyboard.FOUR = 52
keyboard.FIVE = 53
keyboard.SIX = 54
keyboard.SEVEN = 55
keyboard.EIGHT = 56
keyboard.NINE = 57
keyboard.PAGEUP = 33
keyboard.PAGEDOWN = 34
keyboard.HOME = 36
keyboard.END = 35
keyboard.INSERT = 45
keyboard.ESCAPE = 27
keyboard.MINUS = 189
keyboard.PLUS = 187
keyboard.DELETE = 46
keyboard.BACKSPACE = 8
keyboard.LBRACKET = 219
keyboard.RBRACKET = 221
keyboard.BACKSLASH = 220
keyboard.CAPSLOCK = 20
keyboard.SCROLL_LOCK = 145
keyboard.NUMLOCK = 144
keyboard.SEMICOLON = 186
keyboard.QUOTE = 222
keyboard.ENTER = 13
keyboard.SHIFT = 16
keyboard.COMMA = 188
keyboard.PERIOD = 190
keyboard.SLASH = 191
keyboard.GRAVEACCENT = 192
keyboard.CONTROL = 17
keyboard.ALT = 18
keyboard.SPACE = 32
keyboard.UP = 38
keyboard.DOWN = 40
keyboard.LEFT = 37
keyboard.RIGHT = 39
keyboard.TAB = 9
keyboard.WINDOWS = 15
keyboard.MENU = 302
keyboard.PRINTSCREEN = 301
keyboard.BREAK = 19
keyboard.F1 = 112
keyboard.F2 = 113
keyboard.F3 = 114
keyboard.F4 = 115
keyboard.F5 = 116
keyboard.F6 = 117
keyboard.F7 = 118
keyboard.F8 = 119
keyboard.F9 = 120
keyboard.F10 = 121
keyboard.F11 = 122
keyboard.F12 = 123
keyboard.NUMPADZERO = 96
keyboard.NUMPADONE = 97
keyboard.NUMPADTWO = 98
keyboard.NUMPADTHREE = 99
keyboard.NUMPADFOUR = 100
keyboard.NUMPADFIVE = 101
keyboard.NUMPADSIX = 102
keyboard.NUMPADSEVEN = 103
keyboard.NUMPADEIGHT = 104
keyboard.NUMPADNINE = 105
keyboard.NUMPADMINUS = 109
keyboard.NUMPADPLUS = 107
keyboard.NUMPADPERIOD = 110
keyboard.NUMPADMULTIPLY = 106
keyboard.NUMPADSLASH = 111

keyboard.keyList = {
    'ANY', 'NONE',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE',
    'PAGEUP',
    'PAGEDOWN', 'HOME', 'END', 'INSERT', 'ESCAPE', 'MINUS', 'PLUS', 'DELETE',
    'BACKSPACE', 'CAPSLOCK',
    'SCROLL_LOCK', 'NUMLOCK',
    'ENTER', 'SHIFT',
    'QUOTE', 'LBRACKET', 'RBRACKET', 'BACKSLASH', 'SEMICOLON',
    'COMMA', 'PERIOD', 'SLASH', 'GRAVEACCENT',
    'CONTROL', 'ALT',
    'SPACE', 'UP', 'DOWN', 'LEFT', 'RIGHT', 'TAB', 'WINDOWS', 'MENU', 'PRINTSCREEN', 'BREAK',
    'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
    'NUMPADZERO', 'NUMPADONE', 'NUMPADTWO', 'NUMPADTHREE', 'NUMPADFOUR', 'NUMPADFIVE', 'NUMPADSIX', 'NUMPADSEVEN', 'NUMPADEIGHT', 'NUMPADNINE', 'NUMPADMINUS', 'NUMPADPLUS', 'NUMPADPERIOD', 'NUMPADMULTIPLY', 'NUMPADSLASH',
}

function keyboard.getKeyName(id) 
    for _, keyName in ipairs(keyboard.keyList) do
        if keyboard[keyName] == id then
            return keyName 
        end
    end
    return nil
end

function __checkPresses(fn, k)
    -- if they used key indices instead
    if type(k) == 'number' then
        k = keyboard.getKeyName(k)
        if k == nil then
            return false
        end
    end

    k = k:upper()
    if helper.existsFromTable(keyboard.keyList, k) then
        return fn(k)
    end
    return false
end

keyboard.justPressed = {}
setmetatable(keyboard.justPressed, {
    __index = function(t, key) 
        return __checkPresses(keyboardJustPressed, key)
    end
})

keyboard.pressed = {}
setmetatable(keyboard.pressed, {
    __index = function(t, key) 
        return __checkPresses(keyboardPressed, key)
    end
})

keyboard.justReleased = {}
setmetatable(keyboard.justReleased, {
    __index = function(t, key) 
        return __checkPresses(keyboardReleased, key)
    end
})

function __resolveKeybind(keybind)
    local keyBinds = {
        ['note_left']  = { 0, 'l', 'left', 'noteleft' }, 
        ['note_down']  = { 1, 'd', 'down', 'notedown' },
        ['note_up']    = { 2, 'u', 'up', 'noteup' },
	    ['note_right'] = { 3, 'r', 'right', 'noteright' },

	    ['ui_up']    = { },
	    ['ui_left']  = { },
	    ['ui_down']  = { },
	    ['ui_right'] = { },
	    ['accept']   = { 'enter', 'continue' },
	    ['back']     = { 'escape', 'cancel' },

	    ['pause'] = { },
	    ['reset'] = { },

	    ['volume_mute'] = { 'volumemute', 'vol_mute', 'mute' },
	    ['volume_up']   = { 'volumeup',   'vol_up' },
	    ['volume_down'] = { 'volumedown', 'vol_down' },
	    ['debug_1'] = { 'debug1' },
	    ['debug_2'] = { 'debug2' }
    }

    for key, alternatives in pairs(keyBinds) do
        if key == keybind then
            return key
        end

        for i, alternative in ipairs(alternatives) do
            if alternative == keybind then 
                return key 
            end
        end
    end
    return nil
end

function keyboard.getKeybindList(keybind)
    local __keybind = __resolveKeybind(keybind)
    if __keybind == nil then 
        return -1
    end

    return outdate.getPropertyFromClass('ClientPrefs', 'keyBinds.'.. __keybind, true)
end

function keyboard.getKeybind(keybind, index)
    return keyboard.getKeybindList(keybind)[index or 1]
end

function keyboard.getKeybindName(keybind, index)
    return keyboard.getKeyName(keyboard.getKeybind(keybind, index)) or 'NONE'
end

function keyboard.getDisplayName(key) 
    local keys = {
        ZERO = '0', ONE = '1', TWO = '2', THREE = '3', FOUR = '4', FIVE = '5', SIX = '6', SEVEN = '7', EIGHT = '8', NINE = '9',
        PAGEUP = 'PGUP', PAGEDOWN = 'PGDN', INSERT = 'INS', ESCAPE = 'ESC', DELETE = 'DEL',
        MINUS = '-', PLUS = '+',
        BACKSPACE = 'BKSPC',
        LBRACKET = '[', RBRACKET = ']', BACKSLASH = '\\', SLASH = '/',
        CAPSLOCK = 'CAPS', SCROLL_LOCK = 'SCRL', NUMLOCK = 'NUMLCK',
        SEMICOLON = ';', QUOTE = "'", COMMA = ',', PERIOD = '.', GRAVEACCENT = '`',
        CONTROL = 'CTRL', SPACE = 'SPC',
        UP = '↑', DOWN = '↓', LEFT = '←', RIGHT = '→',
        WINDOWS = '⊞', MENU = 'MENU', PRINTSCREEN = 'PSCRN', BREAK = 'BRK',
        NUMPADONE = '#1', NUMPADTWO = '#2', NUMPADTHREE = '#3',
        NUMPADFOUR = '#4', NUMPADFIVE = '#5', NUMPADSIX = '#6',
        NUMPADSEVEN = '#7', NUMPADEIGHT = '#8', NUMPADNINE = '#9', NUMPADZERO ='#0',
        NUMPADMINUS = '#-', NUMPADPLUS = '#+',
        NUMPADPERIOD = '#.', NUMPADMULTIPLY = '#*', NUMPADSLASH = '#/',
    }

    local __key = key:upper()
    if type(key) == 'number' then 
        __key = keyboard.getKeyName(key)
        if __key == nil then 
            return 'NONE'
        end
    end

    return keys[__key] or key
end


return keyboard