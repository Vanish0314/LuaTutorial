-- 10_coding_style.lua
-- 常见 Lua 代码风格和编码规范。

-- 规范 1: 默认使用 local, 避免全局变量污染。
local DEFAULT_STEP = 1

-- 规范 2: 内部 helper 用 local function。
local function assertNumber(value, name)
    if type(value) ~= "number" then
        error(name .. " must be a number", 3)
    end
end

local Counter = {}
Counter.__index = Counter

-- 规范 3: 构造函数不需要 self, 用点。
function Counter.new(value)
    assertNumber(value, "value")

    return setmetatable({
        value = value
    }, Counter)
end

-- 规范 4: 工具函数不依赖实例, 用点。
function Counter.add(a, b)
    assertNumber(a, "a")
    assertNumber(b, "b")
    return a + b
end

-- 规范 5: 实例方法需要 self, 用冒号。
function Counter:increase(step)
    step = step or DEFAULT_STEP
    assertNumber(step, "step")

    self.value = Counter.add(self.value, step)
    return self
end

function Counter:getValue()
    return self.value
end

local counter = Counter.new(10)

counter:increase()
counter:increase(5)

print("counter value:", counter:getValue())

local ok, err = pcall(function()
    counter:increase("bad")
end)

print("错误参数是否成功:", ok)
print("错误信息:", err)

print("编码规范总结:")
print("1. 默认 local, 少用全局变量")
print("2. 需要 self 用冒号, 不需要 self 用点")
print("3. 模块返回表, 内部 helper 不暴露")
print("4. 元方法内部用 rawget/rawset 或私有 data, 避免递归")
print("5. 对外 API 用 assert/error 做参数校验")
