local http = require "resty.http"
local httpc = http.new()

local req_param = {
    method = "GET",
    keepalive_timeout = 60,
    keepalive_pool = 10
}

local res, err = httpc:request_uri("http://127.0.0.1:8500/ui/services", req_param)

if not res then
    ngx.say("failed to request: ", err)
    return
end

ngx.status = res.status

ngx.say(res.body)