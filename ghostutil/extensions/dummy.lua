local dummy = {}

local helper = require 'ghostutil.backend.helper'
local debug = require 'ghostutil.debug'
local bcompat = require 'ghostutil.backwards-compat'
local color = require 'ghostutil.color'
local cpp = require 'ghostutil.cpp'
local file = require 'ghostutil.file'
local github = require 'ghostutil.github'
local modchart = require 'ghostutil.modchart'
local outdate = require 'ghostutil.outdate-handler'
local shader = require 'ghostutil.shader'
local util = require 'ghostutil.util'
local web = require 'ghostutil.web'
local window = require 'ghostutil.window'

-- for GhostUtil
dummy.name = 'dummy' 
dummy.version = '0.0.0'

function dummy.callback(fn, args)
    if fn == 'onCreate' then 
        debugPrint('Dummy extension loaded!')
    end
end

function dummy.fn(a)
    debugPrint(helper.serialize(a, type(a)))
end

return dummy