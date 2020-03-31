-- https://blog.csdn.net/zzhongcy/article/details/85283437
local redis = require "resty.redis"

local count = 0
local delayInSeconds = 30
local redisTimeout = 1000

local function connect(host, port, passwd)
    local rds = redis:new()
    rds:set_timeout(redisTimeout)
    local ok, err = rds:connect(host, port)
    if not ok then
        ngx.log(ngx.ERR, "can't connect to redis: " .. tostring(host) .. ":" .. tostring(port) .. " error: " .. err)
        return nil
    end

    -- 如果访问redis不需要密码，这段代码可以省略
    if passwd ~= nil and passwd ~= ngx.null then
        local count, err_count = rds:get_reused_times() -- 如果需要密码，来自连接池的链接不需要再进行auth验证；如果不做这个判断，连接池不起作用
        if type(count) == "number" and count == 0 then
            local ok, err = rds:auth(passwd)
            if not ok then
                ngx.log(ngx.ERR, "redis auth error: " .. tostring(host) .. ":" .. tostring(port) .. " error: " .. err)
                return nil
            end
        elseif err then
            ngx.log(ngx.ERR, "failed to authenticate: ", err_count)
            rds:close()
            return nil
        end
    end

    return rds
end

local initRedis = function(args)
    local rds = connect("127.0.0.1", 6379, nil)
    if rds == nil then
        ngx.log(ngx.ERR, "rds is nil")
    end
    local value, err = rds:get("libz")
    if value == nil then
        ngx.log(ngx.ERR, err)
    else
        ngx.log(ngx.INFO, "libz",value)
    end

    rds:close()
end

local ok, err = ngx.timer.at(0, initRedis)
if not ok then
    ngx.log(ngx.INFO, "failed to start redis timer ", err)
end

-- 这个args好神奇
local function heartbeatCheck(args)
    count = count + 1
    ngx.log(ngx.INFO, "check ", count)
    if not ok then
        ngx.log(ngx.INFO, "failed to start timer ", err)
    end
end
ngx.timer.every(delayInSeconds,heartbeatCheck)

ngx.log(ngx.NOTICE, "worker start...")
heartbeatCheck()
