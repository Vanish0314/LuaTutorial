-- 04_oop_style_rules.lua
-- Lua OOP 编码规范总结

local function section(text)
    print("")
    print("========== " .. text .. " ==========")
end

section("1. 类表命名")

local Player = {}
Player.__index = Player

function Player.new(name)
    return setmetatable({
        name = name,
        score = 0
    }, Player)
end

function Player:addScore(value)
    self.score = self.score + value
end

function Player:getScore()
    return self.score
end

local player = Player.new("Tom")
player:addScore(10)

print("Player 类表使用大写开头:", Player)
print("player 实例使用小写开头:", player)
print("player score:", player:getScore())

section("2. 点号和冒号")

print("Player.new 不需要 self, 用点号")
print("player:addScore 需要 self, 用冒号")

section("3. 避免太深继承")

print("推荐: 实例 -> 子类 -> 父类")
print("谨慎: 实例 -> A -> B -> C -> D, 查找链太深会难调试")

section("4. 不要滥用元表")

print("推荐: __index 用于方法查找或默认值")
print("谨慎: __index 函数里做复杂业务、IO、隐式创建对象")

section("5. 对外暴露小 API")

local Inventory = {}
Inventory.__index = Inventory

function Inventory.new()
    return setmetatable({
        items = {}
    }, Inventory)
end

function Inventory:add(name, count)
    assert(type(name) == "string", "name must be a string")
    assert(type(count) == "number", "count must be a number")
    assert(count > 0, "count must be positive")

    self.items[name] = (self.items[name] or 0) + count
end

function Inventory:getCount(name)
    return self.items[name] or 0
end

local inventory = Inventory.new()
inventory:add("coin", 3)
inventory:add("coin", 2)

print("inventory:getCount('coin'):", inventory:getCount("coin"))

section("6. 最常用模板")

print([[
local Class = {}
Class.__index = Class

function Class.new(...)
    local self = setmetatable({}, Class)
    -- init fields
    return self
end

function Class:method(...)
    -- use self
end

return Class
]])
