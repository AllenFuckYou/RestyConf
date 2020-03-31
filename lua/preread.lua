--[[
    做格式校验，每个请求只会执行一次
]]

local player = require 'player'
local cache = require 'lrucache'
local struct = require 'struct'
local log = require 'logger'
local bit = require 'bit'
local codec = require 'codec'

local shared_data = ngx.shared.shared_data 


local ctx = ngx.ctx
local sock = assert(ngx.req.socket(true))   -- 建立全双工的socket，产生了一个协程
ctx.sock = sock

local data,err = sock:peek(codec.headLen)
if  data ~= nil then
    local bodayLen,crc,time,msgId,err = codec.decodeMsgHead(data)
    log.print("msg head", time)
else
    ngx.exit(ngx.ERROR)
end  

local uuid = shared_data:incr("counter",1,0)

local p = player.new()
cache.set(uuid, p)

p.gid = 100
p.uuid = uuid
p.name = "pussycat"
ctx.player = p

log.print("preread over")
