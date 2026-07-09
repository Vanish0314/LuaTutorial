-- 02_inheritance.lua
-- 继承 Inheritance
--
-- 目标:
-- 1. 子类复用父类方法
-- 2. 子类可以覆盖父类方法
-- 3. 构造时避免父类 new 再改元表的混乱写法
--
-- Best practice:
-- 父类提供 init(self, ...) 初始化字段。
-- 子类 new 创建自己的实例, 然后显式调用 Parent.init(self, ...)。

local Animal = {}
Animal.__index = Animal

function Animal.init(self, name)
    assert(type(name) == "string", "name must be a string")
    self.name = name
end

function Animal.new(name)
    local instance = setmetatable({}, Animal)
    Animal.init(instance, name)
    return instance
end

function Animal:getName()
    return self.name
end

function Animal:speak()
    return self.name .. " makes a sound"
end

function Animal:describe()
    return self.name .. " is an animal"
end

local Dog = setmetatable({}, {
    __index = Animal
})
Dog.__index = Dog

function Dog.init(self, name, breed)
    Animal.init(self, name)
    assert(type(breed) == "string", "breed must be a string")
    self.breed = breed
end

function Dog.new(name, breed)
    local instance = setmetatable({}, Dog)
    Dog.init(instance, name, breed)
    return instance
end

function Dog:getBreed()
    return self.breed
end

function Dog:speak()
    return self.name .. " barks"
end

function Dog:describe()
    return Animal.describe(self) .. ", breed=" .. self.breed
end

local Cat = setmetatable({}, {
    __index = Animal
})
Cat.__index = Cat

function Cat.init(self, name, color)
    Animal.init(self, name)
    assert(type(color) == "string", "color must be a string")
    self.color = color
end

function Cat.new(name, color)
    local instance = setmetatable({}, Cat)
    Cat.init(instance, name, color)
    return instance
end

function Cat:getColor()
    return self.color
end

function Cat:speak()
    return self.name .. " meows"
end

local dog = Dog.new("Lucky", "Shiba")
local cat = Cat.new("Mimi", "white")

print("dog:getName() 继承自 Animal:", dog:getName())
print("dog:getBreed() 来自 Dog:", dog:getBreed())
print("dog:speak() 覆盖 Animal:", dog:speak())
print("dog:describe() 调用父类再扩展:", dog:describe())

print("cat:getName() 继承自 Animal:", cat:getName())
print("cat:getColor() 来自 Cat:", cat:getColor())
print("cat:speak() 覆盖 Animal:", cat:speak())

print("rawget(dog, 'getName'):", rawget(dog, "getName"))
print("rawget(Dog, 'getName'):", rawget(Dog, "getName"))
print("Dog.getName 通过 Dog 的元表找到 Animal.getName:", Dog.getName)

-- 查找链:
-- dog.getName
-- 1. dog 自己没有 getName
-- 2. dog 的元表是 Dog, Dog.__index = Dog, 所以查 Dog.getName
-- 3. Dog 自己没有 getName
-- 4. Dog 的元表 __index = Animal, 所以查 Animal.getName
