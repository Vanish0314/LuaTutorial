--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 15:42:05
LastEditTime: 2026-07-07 15:44:55
--------------------------------------------------------------------------------
--]]

-- Lua中的简单变量类型
-- nil -> null
-- number
-- string
-- boolean

-- Lua中的复杂数据类型
-- function
-- table
-- userdata
-- thread

-- nil
vNil = nil
print(vNil)

-- number
vNum = 1.43
print(vNum)

-- string
vStr = "string"
print(vStr)

--- boolean
vBool = false
print(vBool)

--
print("----------------------------")

-- 通过type()获取类型
print(type(vNil))
print(type(vNum))
print(type(vStr))
print(type(vBool))

print("----------------------------")

-- type() 返回 string 
print(type(type(nil)))

print("----------------------------")

-- 没有声明的变量被使用不会报错，值为nil
print(b)