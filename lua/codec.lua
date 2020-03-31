-- msg layout
-- short bodyLen 16bit
-- short bodyCrc 16bit
-- int time 32bit
-- int msgId 32bit
-- buffer bodyData

local mp = require "resty.msgpack"
local log = require "logger"
local struct = require "struct"
local stringx = require "stringx"
local crc = require "crc"

local headLen = 12

local _M = {}
_M._version = "0.0.1"
_M.headLen = headLen

function _M.encodeMsg(msg)
    local msgPackData = mp.pack(msg)
    local msgLength = string.len(msgPackData)
    local curTime = os.time()
    local id = msg.m_msgId * ((curTime % 10000) + 1)

    local len = stringx.luaToCByShort(msgLength)
    local time = stringx.luaToCByInt(curTime)
    local msgId = stringx.luaToCByInt(id)
    local check = crc.getCheckSum(time .. msgId, msgLength, msgPackData)
    local checksum = stringx.luaToCByShort(check)

    local tbl = {
        len,
        checksum,
        time,
        msgId,
        msgPackData
    }

    return table.concat(tbl)
end

--- @param buffer data
function _M.decodeMsgHead(data)
    local buffLen = string.len(data)
    if buffLen < headLen then
        return nil,nil,nil,nil,"not enough"
    end

    local bodayLen,crc,time,msgId = struct.unpack("<HHII",data) -- 小端方式读取
    msgId = msgId / ((time % 10000) + 1)
    log.info("head: crc, time, id", bodayLen,crc,time,msgId)

    return bodayLen,crc,time,msgId,nil
end

function _M.decodeMsgBody(buffer)
    local body = mp.unpack(buffer)
    log.info("body",body)
    return body
end

return _M