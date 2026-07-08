-- 01_module_table.lua
-- 主流范式: 模块返回一张表, 所有内部细节尽量 local。
-- 好处:
-- 1. 不污染全局变量
-- 2. API 清晰, require 后拿到的就是模块表
-- 3. 内部 helper 可以隐藏起来

local function createMathxModule()
    local M = {}

    local function checkNumber(value, name)
        if type(value) ~= "number" then
            error(name .. " must be a number", 3)
        end
    end

    function M.add(a, b)
        checkNumber(a, "a")
        checkNumber(b, "b")
        return a + b
    end

    function M.clamp(value, min, max)
        checkNumber(value, "value")
        checkNumber(min, "min")
        checkNumber(max, "max")

        if value < min then
            return min
        end

        if value > max then
            return max
        end

        return value
    end

    return M
end

local mathx = createMathxModule()

print("mathx.add(1, 2):", mathx.add(1, 2))
print("mathx.clamp(15, 0, 10):", mathx.clamp(15, 0, 10))
print("checkNumber 不暴露给外部:", mathx.checkNumber)

-- 真实模块文件通常写法:
-- local M = {}
-- function M.add(a, b) return a + b end
-- return M
