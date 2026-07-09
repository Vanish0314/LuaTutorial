--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-09 11:03:00
LastEditTime: 2026-07-09 11:03:00
--------------------------------------------------------------------------------
--]]
-- 弱表 Weak Tables
-- __mode = "k"  表示弱键
-- __mode = "v"  表示弱值
-- __mode = "kv" 表示键和值都弱

local function section(title)
    print("==========================="..title.."===========================")
end

local function countPairs(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

local function printTable(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

local function fullGC()
    collectgarbage("collect")
    collectgarbage("collect")
end

section("普通表: 会强引用键和值")
do
    local normalTable = {}
    local key = {}

    normalTable[key] = "这个 key 被普通表强引用"
    print("回收前数量", countPairs(normalTable))

    key = nil
    fullGC()

    print("回收后数量", countPairs(normalTable))
    printTable(normalTable)
end

section("弱键表: key 没有其他引用时会被移除")
do
    local weakKeyTable = {}
    setmetatable(weakKeyTable, {__mode = "k"})

    local firstKey = {}
    local secondKey = {}

    weakKeyTable[firstKey] = "first"
    weakKeyTable[secondKey] = "second"
    print("回收前数量", countPairs(weakKeyTable))

    firstKey = nil
    fullGC()

    print("回收后数量", countPairs(weakKeyTable))
    printTable(weakKeyTable)
end

section("弱值表: value 没有其他引用时会被移除")
do
    local weakValueTable = {}
    setmetatable(weakValueTable, {__mode = "v"})

    local firstValue = {name = "first"}
    local secondValue = {name = "second"}

    weakValueTable.first = firstValue
    weakValueTable.second = secondValue
    print("回收前数量", countPairs(weakValueTable))

    firstValue = nil
    fullGC()

    print("回收后数量", countPairs(weakValueTable))
    printTable(weakValueTable)
end

section("弱键弱值表: key 或 value 被回收时条目都会消失")
do
    local weakKVTable = {}
    setmetatable(weakKVTable, {__mode = "kv"})

    local keyA = {}
    local valueA = {name = "valueA"}
    local keyB = {}
    local valueB = {name = "valueB"}

    weakKVTable[keyA] = valueA
    weakKVTable[keyB] = valueB
    print("回收前数量", countPairs(weakKVTable))

    keyA = nil
    valueB = nil
    fullGC()

    print("回收后数量", countPairs(weakKVTable))
    printTable(weakKVTable)
end

section("数字和字符串键: 不会因为弱键而被回收")
do
    local weakKeyTable = {}
    setmetatable(weakKeyTable, {__mode = "k"})

    local objectKey = {}
    weakKeyTable[objectKey] = "对象 key 会被回收"
    weakKeyTable[100] = "数字 key 不会被回收"
    weakKeyTable["name"] = "字符串 key 不会被回收"

    print("回收前数量", countPairs(weakKeyTable))

    objectKey = nil
    fullGC()

    print("回收后数量", countPairs(weakKeyTable))
    printTable(weakKeyTable)
end

section("弱引用的用途: 记录存活对象")
do
    local livingFiles = {}
    setmetatable(livingFiles, {__mode = "v"})

    local fileA = {path = "a.txt"}
    local fileB = {path = "b.txt"}

    livingFiles[1] = fileA
    livingFiles[2] = fileB
    print("当前记录数量", countPairs(livingFiles))

    fileA = nil
    fullGC()

    print("fileA 失去强引用后，记录数量", countPairs(livingFiles))
    printTable(livingFiles)
end
