local bit = require('bit')

local _M = {}

--- @type function 数字存储由大端转为小端
--- @param int value
--- @return string buffer
function _M.luaToCByInt(value)
    return string.char(bit.band(value,0xff),
            bit.band(bit.rshift(value,8),0xff),
            bit.band(bit.rshift(value,16),0xff),
            bit.band(bit.rshift(value,24),0xff))
end

function _M.luaToCByShort(value)
    return string.char(bit.band(value,0xff),
            bit.band(bit.rshift(value,8),0xff))
end

return _M
