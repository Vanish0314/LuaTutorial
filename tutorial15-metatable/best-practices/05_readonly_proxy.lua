-- 05_readonly_proxy.lua
-- 主流范式: 只读代理表。
-- 外部读 proxy.key, 实际读 data.key。
-- 外部写 proxy.key, 统一报错。

local data = {
    VERSION = "1.0.0",
    APP_NAME = "LuaTang",
    MAX_PLAYER = 4
}

local Constants = {}

setmetatable(Constants, {
    __index = data,
    __newindex = function(self, key, value)
        error("cannot modify readonly key: " .. tostring(key), 2)
    end,
    __metatable = "readonly constants"
})

print("Constants.APP_NAME:", Constants.APP_NAME)
print("Constants.MAX_PLAYER:", Constants.MAX_PLAYER)
print("getmetatable(Constants):", getmetatable(Constants))

local ok, err = pcall(function()
    Constants.VERSION = "2.0.0"
end)

print("写入是否成功:", ok)
print("错误信息:", err)

-- 注意:
-- 只读代理保护的是正常写法 Constants.key = value。
-- rawset(Constants, key, value) 可以绕过 __newindex, 所以只读表是约束 API 使用方式。
