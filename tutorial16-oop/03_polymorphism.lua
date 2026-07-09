-- 03_polymorphism.lua
-- 多态 Polymorphism
--
-- 目标:
-- 不关心对象具体是什么类, 只关心它是否支持同一组方法。
--
-- Best practice:
-- 在 Lua 里常用 duck typing:
-- "如果一个对象有 area() 和 describe(), 它就可以当成 Shape 使用。"

local function assertMethod(object, methodName)
    if type(object[methodName]) ~= "function" then
        error("object must implement method: " .. methodName, 3)
    end
end

local Shape = {}
Shape.__index = Shape

function Shape:describe()
    return "unknown shape"
end

local Circle = setmetatable({}, {
    __index = Shape
})
Circle.__index = Circle

function Circle.new(radius)
    assert(type(radius) == "number", "radius must be a number")
    assert(radius > 0, "radius must be positive")

    return setmetatable({
        radius = radius
    }, Circle)
end

function Circle:area()
    return math.pi * self.radius * self.radius
end

function Circle:describe()
    return "circle radius=" .. self.radius
end

local Rectangle = setmetatable({}, {
    __index = Shape
})
Rectangle.__index = Rectangle

function Rectangle.new(width, height)
    assert(type(width) == "number", "width must be a number")
    assert(type(height) == "number", "height must be a number")
    assert(width > 0 and height > 0, "width and height must be positive")

    return setmetatable({
        width = width,
        height = height
    }, Rectangle)
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:describe()
    return "rectangle " .. self.width .. "x" .. self.height
end

local Triangle = setmetatable({}, {
    __index = Shape
})
Triangle.__index = Triangle

function Triangle.new(base, height)
    assert(type(base) == "number", "base must be a number")
    assert(type(height) == "number", "height must be a number")
    assert(base > 0 and height > 0, "base and height must be positive")

    return setmetatable({
        base = base,
        height = height
    }, Triangle)
end

function Triangle:area()
    return self.base * self.height / 2
end

function Triangle:describe()
    return "triangle base=" .. self.base .. ", height=" .. self.height
end

local function printShape(shape)
    assertMethod(shape, "area")
    assertMethod(shape, "describe")

    print(shape:describe(), "area=" .. string.format("%.2f", shape:area()))
end

local function totalArea(shapes)
    local total = 0

    for _, shape in ipairs(shapes) do
        assertMethod(shape, "area")
        total = total + shape:area()
    end

    return total
end

local shapes = {
    Circle.new(3),
    Rectangle.new(4, 5),
    Triangle.new(6, 2)
}

for _, shape in ipairs(shapes) do
    printShape(shape)
end

print("total area:", string.format("%.2f", totalArea(shapes)))

local badShape = {
    describe = function()
        return "bad shape without area"
    end
}

local ok, err = pcall(function()
    printShape(badShape)
end)

print("badShape 是否通过协议检查:", ok)
print("错误信息:", err)

-- 规范:
-- 1. 多态函数不要写 if typeName == "Circle" then ...
-- 2. 让对象自己实现相同方法, 调用方只调用统一接口。
-- 3. 必要时用 assertMethod 在边界处给出清晰错误。
