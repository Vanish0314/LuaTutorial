-- tutorial15-metatable/metatable.lua
-- 元表 metatable 实验
-- 核心思想:
-- 1. 对象自己的字段 = 数据
-- 2. 元表里的 __xxx = 特殊操作的行为规则
-- 3. 普通字段访问先找对象自己; 特殊操作直接查直接元表里的元方法
-- 4. __index / __newindex 可以把读写转发到另一张表, 因此可能形成链或循环

local function title(text)
    print("")
    print("========== " .. text .. " ==========")
end

title("1. __tostring 必须放在元表里")

local obj1 = {
    __tostring = function()
        return "obj1 自己身上的 __tostring"
    end
}

print("obj1.__tostring 是普通字段:", obj1.__tostring)
print("print(obj1) 不会用 obj1.__tostring:")
print(obj1)

local obj2 = {}
setmetatable(obj2, {
    __tostring = function(self)
        return "obj2 的元表 __tostring 被调用"
    end
})

print("print(obj2) 会用 getmetatable(obj2).__tostring:")
print(obj2)

title("2. 元表普通字段不会自动成为对象字段")

local obj3 = {}
setmetatable(obj3, {
    name = "YES",
    __index = {
        name = "Default"
    }
})

print("getmetatable(obj3).name:", getmetatable(obj3).name)
print("getmetatable(obj3).__index.name:", getmetatable(obj3).__index.name)
print("obj3.name:", obj3.name)

title("3. __index 是备用查找规则")

local fallback = {
    name = "Lua",
    age = 30
}

local obj4 = {
    name = "Self Name"
}

setmetatable(obj4, {
    __index = fallback
})

print("obj4.name 自己有, 不触发 __index:", obj4.name)
print("obj4.age 自己没有, 去 fallback.age:", obj4.age)

title("4. __index 可以形成查找链")

local a = {}
local b = {}
local c = {
    value = "found in c"
}

setmetatable(a, { __index = b })
setmetatable(b, { __index = c })

print("a.value -> b.value -> c.value:", a.value)

title("5. Class.__index = Class 的对象范式")

local Person = {}
Person.__index = Person

function Person.new(name)
    local instance = {
        name = name
    }

    setmetatable(instance, Person)
    return instance
end

function Person:say()
    print("I'm " .. self.name)
end

local p = Person.new("Tom")
print("p 自己没有 say:", rawget(p, "say"))
print("p.say 通过 Person.__index 找到:", p.say)
p:say()

title("6. __newindex 拦截不存在字段的写入")

local data = {}
local proxy = {}

setmetatable(proxy, {
    __index = data,
    __newindex = function(self, key, value)
        print("拦截写入:", key, value)
        data[key] = value
    end
})

proxy.name = "Lua"
print("proxy.name 通过 __index 读 data.name:", proxy.name)
print("rawget(proxy, 'name') 仍然是:", rawget(proxy, "name"))

title("7. 在 __newindex 中写自己会递归, rawset 可避免")

local safe = {}

setmetatable(safe, {
    __newindex = function(self, key, value)
        print("safe 写入:", key, value)
        rawset(self, key, value)
    end
})

safe.x = 100
print("safe.x:", safe.x)

title("8. 循环元表本身不会立刻报错")

local loopA = {}
local loopB = {}

setmetatable(loopA, loopB)
setmetatable(loopB, loopA)

print("getmetatable(loopA) == loopB:", getmetatable(loopA) == loopB)
print("getmetatable(loopB) == loopA:", getmetatable(loopB) == loopA)
print("loopA.missing 没有 __index, 所以只是 nil:", loopA.missing)

title("9. 循环 __index 会造成查找循环")

local indexA = {}
local indexB = {}

setmetatable(indexA, { __index = indexB })
setmetatable(indexB, { __index = indexA })

local ok, err = pcall(function()
    print(indexA.missing)
end)

print("读取 indexA.missing 是否成功:", ok)
print("错误信息:", err)

title("10. 总结")

print("普通字段访问: obj.key -> 先找 obj 自己, 找不到才看 getmetatable(obj).__index")
print("特殊操作: tostring(obj), obj(), obj + other -> 直接查直接元表里的 __tostring/__call/__add")
print("__index/__newindex 指向表时会转发读写, 因此可能形成链")
print("元表互相引用不一定有问题; 循环 __index/__newindex 才容易报 loop")
