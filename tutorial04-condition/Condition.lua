--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 15:42:05
LastEditTime: 2026-07-07 16:28:56
--------------------------------------------------------------------------------
--]]

-- 条件分支

condition = 114514

if condition then -- 之后都要有 then
    print ("condition>5")
elseif condition == 5 then -- elseif 连着写的
    print("condition=5")
else
    print("condition<5")
end

-- Switch
-- Lua中没有, 需要自己实现