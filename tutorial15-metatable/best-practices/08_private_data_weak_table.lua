-- 08_private_data_weak_table.lua
-- 主流范式: 用弱键表保存私有数据。
-- 对象对外是空表, 内部状态放在 private[object] 中。

local private = setmetatable({}, {
    __mode = "k"
})

local User = {}
User.__index = User

function User.new(name, token)
    local instance = setmetatable({}, User)

    private[instance] = {
        name = name,
        token = token
    }

    return instance
end

function User:getName()
    return private[self].name
end

function User:rename(name)
    private[self].name = name
end

function User:checkToken(token)
    return private[self].token == token
end

local user = User.new("Alice", "secret-token")

print("user.name 直接访问不到:", user.name)
print("user.token 直接访问不到:", user.token)
print("通过方法读取 name:", user:getName())
print("token 是否正确:", user:checkToken("secret-token"))

user:rename("Ada")

print("改名后:", user:getName())

-- 规范:
-- __mode = "k" 表示 weak keys。
-- 当 user 对象没人引用时, private[user] 也可以被 GC 清理。
