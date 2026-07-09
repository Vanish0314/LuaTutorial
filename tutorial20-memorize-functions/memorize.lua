--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-09 11:17:00
LastEditTime: 2026-07-09 11:17:00
--------------------------------------------------------------------------------
--]]
-- 记忆函数 Memorize Functions
-- 记忆函数的核心思想: 相同参数算过一次后，把结果缓存起来，后续直接复用。
-- 如果缓存表使用弱值，就不会把已经没人使用的结果永远留在内存里。

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

local function loadCode(source)
    local used = false

    return assert(load(function()
        if used then
            return nil
        end

        used = true
        return source
    end))
end

section("记忆 load 的结果")
do
    local results = {}
    setmetatable(results, {__mode = "v"}) -- 字符串作为 key，编译出的函数作为弱 value

    local compileCount = 0

    local function memLoadString(s)
        local res = results[s]

        if res == nil then
            compileCount = compileCount + 1
            res = loadCode(s)
            results[s] = res
        end

        return res
    end

    local source = "return 10 + 20"
    local firstFunc = memLoadString(source)
    local secondFunc = memLoadString(source)

    print("第一次和第二次是否同一个函数", firstFunc == secondFunc)
    print("执行结果", firstFunc())
    print("实际编译次数", compileCount)
    print("缓存数量", countPairs(results))

    firstFunc = nil
    secondFunc = nil
    fullGC()

    print("释放函数强引用后的缓存数量", countPairs(results))

    local thirdFunc = memLoadString(source)
    print("重新取得后的执行结果", thirdFunc())
    print("实际编译次数", compileCount)
end

section("普通缓存的问题")
do
    local results = {}

    local function memLoadString(s)
        local res = results[s]

        if res == nil then
            res = loadCode(s)
            results[s] = res
        end

        return res
    end

    local firstFunc = memLoadString("return 'only once 1'")
    local secondFunc = memLoadString("return 'only once 2'")
    print("回收前缓存数量", countPairs(results))

    firstFunc = nil
    secondFunc = nil
    fullGC()

    print("回收后缓存数量", countPairs(results))
end

section("记忆颜色工厂")
do
    local results = {}
    setmetatable(results, {__mode = "v"}) -- key 是颜色字符串，value 是颜色 table

    local createCount = 0

    local function createRGB(r, g, b)
        local key = string.format("%d-%d-%d", r, g, b)
        local color = results[key]

        if color == nil then
            createCount = createCount + 1
            color = {red = r, green = g, blue = b}
            results[key] = color
        end

        return color
    end

    local red1 = createRGB(255, 0, 0)
    local red2 = createRGB(255, 0, 0)
    local blue1 = createRGB(0, 0, 255)
    local blue2 = createRGB(0, 0, 255)

    print("red1 == red2", red1 == red2)
    print("blue1 == blue2", blue1 == blue2)
    print("red1 == blue1", red1 == blue1)
    print("实际创建颜色数量", createCount)
    print("缓存数量", countPairs(results))

    red1 = nil
    red2 = nil
    fullGC()

    print("释放红色强引用后的缓存数量", countPairs(results))

    local red3 = createRGB(255, 0, 0)
    print("重新创建红色", red3.red, red3.green, red3.blue)
    print("实际创建颜色数量", createCount)
    print("缓存数量", countPairs(results))
end

section("弱值表也可以写成 kv")
do
    local results = {}
    setmetatable(results, {__mode = "kv"})

    local color = {red = 128, green = 128, blue = 128}
    results["128-128-128"] = color

    print("回收前缓存数量", countPairs(results))

    color = nil
    fullGC()

    print("回收后缓存数量", countPairs(results))
end
