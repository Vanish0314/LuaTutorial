--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-09 10:47:14
LastEditTime: 2026-07-09 10:49:45
--------------------------------------------------------------------------------
--]]
--获取当前lua占用字节数
local function currentMemoryUsed()
    print("当前占用了"..collectgarbage("count").."KB")
end

local function section(section)
    print("==========================="..section.."===========================")
end


section("Snapshot #1")
currentMemoryUsed()

local newVariable = {id = 1, name="newVariable"}
newVariable.myHugeContent = string.rep("x", 1024^2)

section("Snapshot #2")
currentMemoryUsed()

collectgarbage("collect")

section("Snapshot #3")
currentMemoryUsed()

newVariable = nil

section("Snapshot #4")
currentMemoryUsed()

collectgarbage("collect")

section("Snapshot #5")
currentMemoryUsed()