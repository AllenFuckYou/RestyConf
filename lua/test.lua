print('this is a test file')
ngx.say('hello world');
local x = os.clock();

print(os.clock())
local s = 0;
for i = 1, 100000000 do
      s = s + i;
end
print(string.format("elapsed time : %.2f\n", os.clock() - x));

local ffi = require("ffi")
ffi.cdef[[
int printf(const char *fmt, ...);
]]
ffi.C.printf("Hello %s", "world")

