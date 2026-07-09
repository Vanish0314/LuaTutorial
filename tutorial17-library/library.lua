--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-09 10:37:04
LastEditTime: 2026-07-09 10:37:31
--------------------------------------------------------------------------------
--]]
-- 时间库
print(os.time())
local now = os.date("*t")
for k,v in pairs(now) do
    print(k,v)
end

-- math
print(math.abs(-11))
math.randomseed(os.time())
print(math.random())
print(math.random())

-- package
print(package.path)
for k,v in pairs(_G) do
    print(k,v)
end