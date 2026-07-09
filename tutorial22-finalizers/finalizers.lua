--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-09 11:37:00
LastEditTime: 2026-07-09 11:45:00
--------------------------------------------------------------------------------
--]]
-- 终结器 Finalizers
-- 垃圾回收器的主要目标是回收 Lua 对象。
-- 通过 __gc 元方法，它也可以在对象被回收前，帮我们释放外部资源。
-- Lua 5.2+ 支持 table 的 __gc；Lua 5.1 可以用 newproxy 创建带 __gc 的 userdata。

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

local function memoryKB()
    return string.format("%.2f KB", collectgarbage("count"))
end

local function detectTableGC()
    local called = false
    local o = setmetatable({}, {
        __gc = function()
            called = true
        end
    })

    o = nil
    collectgarbage("collect")

    return called
end

local tableGCSupported = detectTableGC()
local newproxySupported = type(newproxy) == "function"

local function makeFinalizable(data, finalizer)
    if tableGCSupported then
        local obj = data
        setmetatable(obj, {
            __gc = function(self)
                finalizer(self, self)
            end
        })

        return obj, data
    end

    local obj = newproxy(true)
    local mt = getmetatable(obj)

    mt.__gc = function(self)
        finalizer(data, self or obj)
    end

    return obj, data
end

section("当前 Lua 版本")
print(_VERSION)
print("table 是否支持 __gc", tableGCSupported)
print("newproxy 是否可用", newproxySupported)

if not tableGCSupported and not newproxySupported then
    print("当前环境无法演示终结器: 需要 Lua 5.2+ 的 table __gc，或 Lua 5.1 的 newproxy")
    return
end

if tableGCSupported then
    print("本教程将直接使用 table 演示 __gc")
else
    print("本教程将使用 userdata 演示 __gc，因为 Lua 5.1 的 table 没有终结器")
end

section("__gc 基础")
do
    local o = makeFinalizable({x = "hi"}, function(data)
        print("终结对象", data.x)
    end)

    o = nil
    collectgarbage("collect")
end

section("只有设置元表时已有 __gc，对象才会被标记为终结")
if tableGCSupported then
    local o = {x = "late __gc"}
    local mt = {}
    setmetatable(o, mt)

    mt.__gc = function(obj)
        print("这行通常不会出现", obj.x)
    end

    o = nil
    collectgarbage("collect")
    print("后补 __gc 结束")
else
    print("Lua 5.1 的 table 不支持 __gc，所以这里无法触发表终结器")
    print("要观察这个标记时机，请使用 Lua 5.2+ 运行本文件")
end

section("__gc 占位符")
if tableGCSupported then
    local o = {x = "placeholder __gc"}
    local mt = {__gc = true}
    setmetatable(o, mt)

    mt.__gc = function(obj)
        print("占位符让对象被正确终结", obj.x)
    end

    o = nil
    collectgarbage("collect")
else
    print("Lua 5.2+ 中，可以先写 mt = {__gc = true}，之后再替换成真正函数")
end

section("多个终结器的调用顺序")
do
    local list = nil

    for i = 1, 3 do
        list = makeFinalizable({index = i, link = list}, function(data)
            print("终结对象编号", data.index)
        end)
    end

    list = nil
    collectgarbage("collect")
    print("最后被标记的对象，会最先运行终结器")
end

section("终结器中的短暂复活")
do
    local o = makeFinalizable({name = "transient"}, function(data, obj)
        print("终结器收到对象参数", type(obj), data.name)
    end)

    o = nil
    collectgarbage("collect")
end

section("永久复活")
do
    local revivedObject = nil
    local revivedData = nil

    local o = makeFinalizable({name = "permanent"}, function(data, obj)
        revivedObject = obj
        revivedData = data
        print("终结器把对象保存起来", data.name)
    end)

    o = nil
    collectgarbage("collect")

    print("终结器返回后仍能访问对象", type(revivedObject), revivedData.name)

    revivedObject = nil
    revivedData = nil
    fullGC()
    print("释放复活引用后，终结器不会再次运行")
end

section("复活是传递性的")
do
    local A = {x = "this is A"}
    local B = {f = A}

    local o = makeFinalizable(B, function(data)
        print("B 的终结器仍能访问 A", data.f.x)
    end)

    A = nil
    B = nil
    o = nil
    collectgarbage("collect")
end

section("带终结器的对象需要两个阶段才真正释放")
do
    local finalized = false

    local o = makeFinalizable({name = "two-phase"}, function(data)
        finalized = true
        print("第一次回收: 运行终结器", data.name)
    end)

    o = nil
    collectgarbage("collect")
    print("第一次回收后 finalized", finalized)

    collectgarbage("collect")
    print("第二次回收: 对象已经终结过，不会再调用 __gc")
end

section("atexit 写法")
do
    local o = makeFinalizable({name = "atexit"}, function()
        print("Lua 状态关闭前运行 atexit 代码")
    end)

    _G["*TUTORIAL22_ATEXIT*"] = o

    print("atexit 对象已挂到全局表，最后一行输出会在程序退出时出现")
end

section("每个 GC 周期运行一次函数")
do
    local remainingCycles = 3
    local createTrigger = nil

    createTrigger = function(index)
        makeFinalizable({index = index}, function(data)
            print("新的周期", data.index)
            remainingCycles = remainingCycles - 1

            if remainingCycles > 0 then
                createTrigger(data.index + 1)
            end
        end)
    end

    createTrigger(1)

    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
end

section("终结器与弱表")
do
    local weakValues = setmetatable({}, {__mode = "v"})
    local weakKeys = setmetatable({}, {__mode = "k"})

    local o = makeFinalizable({name = "weak-table-object"}, function(data, obj)
        print("终结器中，弱值表还能取到对象", weakValues.slot ~= nil)
        print("终结器中，弱键表属性", weakKeys[obj])
        print("终结对象名", data.name)
    end)

    weakValues.slot = o
    weakKeys[o] = "保存在弱键表里的属性"

    o = nil
    collectgarbage("collect")

    print("一次回收后，弱键表条目数量", countPairs(weakKeys))
    collectgarbage("collect")
    print("再次回收后，弱键表条目数量", countPairs(weakKeys))
end

section("collectgarbage 常用控制项")
do
    print("当前内存", memoryKB())

    local oldPause = collectgarbage("setpause", 200)
    local oldStepMul = collectgarbage("setstepmul", 200)

    print("旧 pause", oldPause)
    print("旧 stepmul", oldStepMul)
    print("pause 越低，回收器越快重新开始新周期")
    print("stepmul 越高，每次分配触发的回收工作越多")

    collectgarbage("stop")

    local trash = {}
    for i = 1, 1000 do
        trash[i] = {value = i, payload = string.rep("x", 64)}
    end

    print("停止自动 GC 后分配内存", memoryKB())

    trash = nil
    collectgarbage("restart")

    local cycleFinished = collectgarbage("step", 0)
    print("step 是否完成了一个回收周期", cycleFinished)

    collectgarbage("collect")
    print("完整回收后内存", memoryKB())

    collectgarbage("setpause", oldPause)
    collectgarbage("setstepmul", oldStepMul)
end

