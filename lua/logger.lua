local cjson = require 'cjson'

local log = ngx.log

local emerg =  ngx.EMERG
local alert = ngx.ALERT
local crit = ngx.CRIT
local err = ngx.ERR
local warn = ngx.WARN
local notice = ngx.NOTICE
local info = ngx.INFO
local debug = ngx.DEBUG

--- @class logger
local _M = {}

---@vararg string
---@return boolean
function _M.emerg(...)
    return log(emerg, ...)
end

function _M.alert(...)
    return log(alert, ...)
end

function _M.crit(...)
    return log(crit, ...)
end

function _M.err(...)
    return log(err, ...)
end

function _M.warn(...)
    return log(warn, ...)
end

function _M.notice(...)
    return log(notice, ...)
end

--- @vararg string
--- @return boolean
function _M.info (...)
    local arg = {...}
    for index, value in ipairs(arg) do
        if type(value) == 'table' then
            arg[index] = cjson.encode(value)
        end
    end
    return log(info, table.concat(arg," "))
end

function _M.debug(...)
    local arg = {...}
    return log(debug, table.concat(arg," "))
end

_M.print = _M.info

return _M
