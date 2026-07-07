--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 15:42:05
LastEditTime: 2026-07-07 16:28:56
--------------------------------------------------------------------------------
--]]

-- While

it = 0 
while it < 5 do
    print(it)
    it = it + 1
end

print("=====================")

-- do while

it = 0
repeat
    print(it)
    it = it + 1
until it > 5 -- 其他语言中都是循环条件 而非跳出条件

print("=====================")

-- for

for i =1,5 do -- i=1 赋值 ','表示, 当i >= 5时结束; for中i默认自增
    print(i)
end

print("---------------------")


for i = 1, 8,3 do -- 第二个',' 表示增量
    print(i)
end

print("---------------------")

for i = 10 ,0,-3 do
    print(i)
end