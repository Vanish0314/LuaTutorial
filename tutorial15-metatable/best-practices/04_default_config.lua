-- 04_default_config.lua
-- 主流范式: 用 __index 做默认配置。
-- 用户配置优先, 用户没写的字段才去 defaults 里找。

local defaults = {
    width = 1280,
    height = 720,
    title = "Lua Game",
    fullscreen = false
}

local function newConfig(userConfig)
    return setmetatable(userConfig or {}, {
        __index = defaults
    })
end

local config = newConfig({
    title = "Metatable Demo"
})

print("用户覆盖 title:", config.title)
print("默认 width:", config.width)
print("默认 fullscreen:", config.fullscreen)
print("rawget(config, 'width'):", rawget(config, "width"))

config.width = 1920

print("写入 config.width 后:", config.width)
print("defaults.width 不变:", defaults.width)

-- 规范:
-- 1. 默认表 defaults 通常不要在运行中修改。
-- 2. __index 适合做读取兜底。
-- 3. 如果要保存最终配置, 可以把默认值和用户值合并成一张普通表。
