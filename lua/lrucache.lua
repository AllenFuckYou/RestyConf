local _M = {}
 
local lrucache = require "resty.lrucache"
 
local c, err = lrucache.new(10000)
if not c then
    return error("failed to create the cache: " .. (err or "unknown"))
end
 
function _M.set(key, value)
    c:set(key, value)
end
 
function _M.get(key)
    return c:get(key)
end
 
function _M.delete(key)
    c:delete(key)
end
 
return _M