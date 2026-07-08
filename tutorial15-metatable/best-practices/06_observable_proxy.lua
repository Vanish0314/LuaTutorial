-- 06_observable_proxy.lua
-- 主流范式: 代理表监听字段读写。
-- 常用于调试、配置系统、数据绑定、状态变化通知。

local data = {}
local watchers = {}
local state = {}

local function watch(key, callback)
    watchers[key] = callback
end

setmetatable(state, {
    __index = function(self, key)
        print("读取字段:", key)
        return data[key]
    end,

    __newindex = function(self, key, value)
        local oldValue = data[key]

        if oldValue == value then
            return
        end

        data[key] = value

        local callback = watchers[key]
        if callback then
            callback(oldValue, value)
        end
    end
})

watch("hp", function(oldValue, newValue)
    print("hp 变化:", oldValue, "->", newValue)
end)

state.hp = 100
state.hp = 80
state.hp = 80

print("当前 hp:", state.hp)
print("state 自己没有 hp:", rawget(state, "hp"))

-- 规范:
-- 在 __index / __newindex 内部操作真实数据时, 用 data[key] 或 rawget/rawset。
-- 不要在 __index 中 return self[key], 否则会递归触发 __index。
