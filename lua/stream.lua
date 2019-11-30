-- 官网手册 https://github.com/openresty/stream-lua-nginx-module
-- https://blog.csdn.net/u012839304/article/details/64920257

local sock = assert(ngx.req.socket(true))

while true do
    local data,err = sock:receive()
    if data == nil then
        ngx.print("failed to recv req: ".. err)
        ngx.log(ngx.DEBUG, "failed to recv req: ".. err)
        break
    end
    ngx.print("resp:")
    ngx.flush(true)  -- flush any pending output and wait
    ngx.sleep(1)
    ngx.say(data) -- say会默认增加一个换行
    -- ngx.print("resp:".. data) -- 和say不同，原样转发内容
    ngx.log(ngx.DEBUG, "recv req: ".. data)
end