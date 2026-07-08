--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-08 17:47:53
LastEditTime: 2026-07-08 17:49:24
--------------------------------------------------------------------------------
--]]

-- 执行其他脚本
require("script1")

-- 一个脚本不卸载无法再次执行
i = 1
repeat
    print("第"..i.."次")
    require("script1")
    i = i+1
until i == 5

-- 脚本执行情况由package存储
for i, k in pairs(package.loaded) do
    print(i ..": ".. tostring(i) .. " k " .. tostring(k))
end

-- 重复执行需要先卸载(即更改package)再执行
i = 1
repeat
    print("第" .. i .. "次")
    package.loaded["script1"] = nil
    require("script1")
    i = i + 1
until i == 5

-- 大G表, 存储所有全局变量

print("\n 大G表 \n")
for k,v in pairs(_G) do
    print(k,v)
end

-- script 可以返回
print(require("scriptReturnsFuckYou")[1],require("scriptReturnsFuckYou")[2])