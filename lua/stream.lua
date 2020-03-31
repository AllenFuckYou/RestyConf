-- 官网手册 https://github.com/openresty/stream-lua-nginx-module
-- https://blog.csdn.net/u012839304/article/details/64920257
-- https://www.cnblogs.com/datiangou/p/10260800.html
-- https://blog.csdn.net/sky6even/article/details/90634412
-- https://blog.csdn.net/yangjian_9276/article/details/86679937
-- https://blog.csdn.net/u014348296/article/details/104968084

--[[
    stream处理阶段：
    1.
    sock方法：
    1.receive
    2.receiveuntil
    3.send
    4.peek

    包调用时 .
    对象调用时 :

    ngx.var:
    1.binary_remote_addr 客户端二进制地址
    2.msec 当前的Unix时间戳
    3.nginx_version nginx版本
    4.pid 工作进程的PID
    5.remote_addr,remote_port 客户端地址和端口
    6.server_addr 服务器端地址
    7.server_name,server_port
    8.tcpinfo_rtt, $tcpinfo_rttvar, $tcpinfo_snd_cwnd, $tcpinfo_rcv_space 客户端TCP连接的具体信息
    9.time_local 服务器时间
]]

local cjson = require "cjson"
local redis = require "resty.redis"
local cache = require "lrucache"
local log = require "logger"
local codec = require "codec"
require "player"

local ctx = ngx.ctx
local remote_addr = ngx.var.remote_addr
local shared_data = ngx.shared.shared_data
local sock = ctx.sock
local player = ctx.player

--[[
    while true do
        1.检查状态，如果出问题直接退出
        2.read data 到buff
        while true do
            3.循环处理buff内的消息，handlerMsg(ctx) 将上下文传进去方便发送消息到client
            4.如果不够一个消息则 break
        end
    end
]]

local function on_sock_abort()
    log.info(player.uuid, " is close")
end

ngx.on_abort(on_sock_abort)

while true do
    local data,err = sock:receive(codec.headLen) -- 读出就被消耗了，不能二次读取。peek可以查看数据但不消耗
    if data == nil then
        log.info("failed to recv req: ".. err)
        break
    end
    
    local bodayLen,crc,time,msgId,err = codec.decodeMsgHead(data)
    if err ~= nil then
        log.info("failed to decode req: ".. err)
        break
    end

    local body,err = sock:receive(bodayLen)
    body = codec.decodeMsgBody(body)

    local p = cache.get(player.uuid)
    local ret = {
        m_msgId = 16,
        m_time = ngx.time(),
        m_name = p.name
    }
    sock:send(codec.encodeMsg(ret))
end
