local _M = {}
_M._version = "0.0.1"

local mt = { __index = _M } --元表

-- @type number id 
function _M.new(self)
    local obj = {
        uuid = 0,
        gid = 0,
        appId = 0,
        userId = 0,
        login = 0,
        state = 0,
        logicId = 0,
        loginMod = 0,

    }
    return setmetatable(obj, mt)
end

return _M
