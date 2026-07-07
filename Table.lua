--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 15:42:05
LastEditTime: 2026-07-07 17:34:16
--------------------------------------------------------------------------------
--]]

print("--------------------------")
-- #1 数组
emptyTable = {} -- 声明一个空表
filledTable = {1,nil,2,"第三个非nil",true,nil,function() print("I'm a func") end,nil,nil}
print(filledTable)
print(filledTable[0]) --Lua 中索引不是从0开始, 所以[0]为nil
print(filledTable[1])
print(string.format("数组长度为%d,使用#来获取. 注意长度计算会忽略掉所有的nil(好坑爹)",#filledTable))

-- #2 二维数组
doubleArr = {{1,2},{3,4}} --Lua中的二维数组只是表现而非设计, 表现上和二维数组一样, 但设计上只是因为表内容可以是任何类型

print("--------------------------")
-- #3 数组遍历
print("不可靠table遍历方法, 通过for循环")
for i = 1, #filledTable do
    print(filledTable[i])
end

print("ipairs 从下标 1 开始，一直遍历到第一个 nil 为止, 也是坑")
arr = { "a", nil, "c" }
for i, v in ipairs(arr) do
    print(i, v)
end

-- Lua中在没有额外信息情况下, 无法得知table中nil数量为多少

print("--------------------------")
-- #4 自定义索引
arrWithCustomIndex = {[0] = 0, 1,2,3,[-1]=-1,5,[100] = 100}
for i = -1 , 4 do
    print(arrWithCustomIndex[i])
end
print("table项数不计算自定义索引,为:"..#arrWithCustomIndex)
for i = 1, #arrWithCustomIndex do
    print(arrWithCustomIndex[i])
end