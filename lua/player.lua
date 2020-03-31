--- @class Player @玩家类
local _M = {}
_M._version = "0.0.1"

--- @class Player @玩家类
local mt = { __index = _M } --元表

--- 创建新玩家
--- @type number id 
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
        name = "none",
    }
    return setmetatable(obj, mt)
end

function _M.get_uuid(self)
    return self.uuid
end

function _M.get_logicId(self)
    return self.logicId
end

return _M