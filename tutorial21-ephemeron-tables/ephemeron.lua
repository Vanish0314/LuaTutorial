--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-09 11:34:00
LastEditTime: 2026-07-09 11:34:00
--------------------------------------------------------------------------------
--]]
-- 星历表 Ephemeron Tables
-- Lua 5.2+ 中，弱键强值表 __mode = "k" 具有星历表语义。
-- 对于 mem[k] = v，只有 k 在表外部仍然可达时，v 才会被 mem 强引用。
-- Lua 5.1 没有这个语义，所以 value 反过来引用 key 时，可能造成缓存条目无法回收。

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

local function fullGC()
    collectgarbage("collect")
    collectgarbage("collect")
end

section("当前 Lua 版本")
print(_VERSION)

section("普通常量函数工厂")
do
    local function factory(o)
        return function()
            return o
        end
    end

    local object = {name = "apple"}
    local firstFunc = factory(object)
    local secondFunc = factory(object)

    print("相同对象生成的两个函数是否相同", firstFunc == secondFunc)
    print("函数返回的对象", firstFunc().name)
end

section("带记忆功能的常量函数工厂")
do
    local mem = {}
    setmetatable(mem, {__mode = "k"})

    local createCount = 0

    local function factory(o)
        local res = mem[o]

        if res == nil then
            createCount = createCount + 1
            res = function()
                return o
            end
            mem[o] = res
        end

        return res
    end

    local object = {name = "banana"}
    local firstFunc = factory(object)
    local secondFunc = factory(object)

    print("相同对象生成的两个函数是否相同", firstFunc == secondFunc)
    print("实际创建函数数量", createCount)
    print("回收前缓存数量", countPairs(mem))

    object = nil
    firstFunc = nil
    secondFunc = nil
    fullGC()

    local count = countPairs(mem)
    print("释放外部引用后的缓存数量", count)

    if count == 0 then
        print("当前环境支持星历表语义: value 指回 key 也不会阻止 key 被回收")
    else
        print("当前环境没有星历表语义: value 闭包指回 key，导致缓存条目仍然存在")
    end
end

section("为什么这里会形成循环")
do
    local mem = {}
    setmetatable(mem, {__mode = "k"})

    local object = {name = "circle"}
    local func = function()
        return object
    end

    mem[object] = func

    print("mem 弱引用 object 作为 key")
    print("mem 强引用 func 作为 value")
    print("func 闭包又强引用 object")
    print("这就形成了 mem -> func -> object -> mem条目 的循环")
end

section("kv 可以避免 Lua 5.1 的泄漏，但缓存更容易失效")
do
    local mem = {}
    setmetatable(mem, {__mode = "kv"})

    local createCount = 0

    local function factory(o)
        local res = mem[o]

        if res == nil then
            createCount = createCount + 1
            res = function()
                return o
            end
            mem[o] = res
        end

        return res
    end

    local object = {name = "orange"}
    local firstFunc = factory(object)

    print("第一次创建后缓存数量", countPairs(mem))

    firstFunc = nil
    fullGC()

    print("object 仍然存在，但函数失去强引用后的缓存数量", countPairs(mem))

    local secondFunc = factory(object)
    print("再次请求后实际创建函数数量", createCount)
    print("新函数返回的对象", secondFunc().name)

    object = nil
    secondFunc = nil
    fullGC()

    print("全部外部引用释放后的缓存数量", countPairs(mem))
end
