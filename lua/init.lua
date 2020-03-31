local cjson = require 'cjson'
local redis = require "resty.redis"
local core = require 'resty.core'
local config = require 'config'


count = 1
conf = config

local shared_data = ngx.shared.shared_data --共享全局内存
shared_data:set("password", "password")
