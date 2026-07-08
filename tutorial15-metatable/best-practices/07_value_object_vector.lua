-- 07_value_object_vector.lua
-- 主流范式: 值对象 + 运算符重载。
-- 适合 Vector、Color、Matrix、TimeSpan 这类值语义对象。

local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, Vector)
end

function Vector.__add(a, b)
    return Vector.new(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    return Vector.new(a.x - b.x, a.y - b.y)
end

function Vector.__eq(a, b)
    return a.x == b.x and a.y == b.y
end

function Vector.__tostring(v)
    return "(" .. v.x .. ", " .. v.y .. ")"
end

function Vector:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

local a = Vector.new(3, 4)
local b = Vector.new(1, 2)
local c = Vector.new(3, 4)

print("a:", a)
print("b:", b)
print("a + b:", a + b)
print("a - b:", a - b)
print("a == c:", a == c)
print("a:length():", a:length())

-- 规范:
-- 1. 元方法和普通方法都放在 Vector 类表里。
-- 2. 实例的元表也是 Vector。
-- 3. Vector.__index = Vector 让实例能找到普通方法。
