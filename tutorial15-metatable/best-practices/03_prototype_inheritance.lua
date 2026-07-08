-- 03_prototype_inheritance.lua
-- 主流范式: 原型继承。
-- 查找链: dog 实例 -> Dog 类表 -> Animal 父类表。

local Animal = {}
Animal.__index = Animal

function Animal.new(name)
    return setmetatable({
        name = name
    }, Animal)
end

function Animal:describe()
    return self.name .. " is an animal"
end

function Animal:speak()
    return self.name .. " makes a sound"
end

local Dog = setmetatable({}, {
    __index = Animal
})
Dog.__index = Dog

function Dog.new(name, breed)
    local instance = Animal.new(name)
    instance.breed = breed
    setmetatable(instance, Dog)
    return instance
end

function Dog:speak()
    return self.name .. " barks"
end

function Dog:getBreed()
    return self.breed
end

local dog = Dog.new("Lucky", "Shiba")

print("Dog 覆盖 speak:", dog:speak())
print("Dog 自己的方法:", dog:getBreed())
print("Animal 父类方法:", dog:describe())

print("dog 自己没有 describe:", rawget(dog, "describe"))
print("Dog 自己没有 describe:", rawget(Dog, "describe"))
print("Dog 通过元表找到 Animal.describe:", Dog.describe)
