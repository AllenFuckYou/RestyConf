local bit = require('bit')

local _M = {}

local function ByteCRC(sum, data)
    local sum = bit.bxor(sum, data)
    for i = 0, 3 do
        if (bit.band(sum, 1) == 0) then
            sum = math.floor(sum / 2)
        else
            sum = bit.bxor(math.floor(sum / 2), 0x70B1)
        end
    end
    return sum
end

--- 循环冗余校验
local function CRC(data, length)
    local sum = 0xFFFF
    for i = 1, length do
        local d = string.byte(data, i)
        sum = ByteCRC(sum, d)
    end
    return sum
end

function _M.getCheckSum(time, msgLength, msgPackData)
    local crc = ""
    local len = string.len(time) + msgLength
    if len < 8 then
        crc = CRC(time .. msgPackData, len)
    else
        crc = CRC(time .. msgPackData, 8)
    end
    return crc
end

return _M
