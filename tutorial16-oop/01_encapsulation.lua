-- 01_encapsulation.lua
-- 封装 Encapsulation
--
-- 目标:
-- 1. 外部不能直接读写对象内部状态
-- 2. 外部只能通过方法操作对象
-- 3. 方法内部负责参数校验和状态保护
--
-- Best practice:
-- 用弱键表 private 保存私有数据。
-- 实例表本身不直接保存 owner/balance 等业务字段。

local private = setmetatable({}, {
    __mode = "k"
})

local BankAccount = {}
BankAccount.__index = BankAccount
BankAccount.__metatable = "BankAccount metatable is locked"

BankAccount.__newindex = function(self, key, value)
    error("cannot write field directly: " .. tostring(key), 2)
end

function BankAccount.new(owner, balance)
    assert(type(owner) == "string", "owner must be a string")
    assert(type(balance) == "number", "balance must be a number")
    assert(balance >= 0, "balance must be non-negative")

    local instance = setmetatable({}, BankAccount)

    private[instance] = {
        owner = owner,
        balance = balance
    }

    return instance
end

function BankAccount:getOwner()
    return private[self].owner
end

function BankAccount:getBalance()
    return private[self].balance
end

function BankAccount:deposit(amount)
    assert(type(amount) == "number", "amount must be a number")
    assert(amount > 0, "amount must be positive")

    private[self].balance = private[self].balance + amount
end

function BankAccount:withdraw(amount)
    assert(type(amount) == "number", "amount must be a number")
    assert(amount > 0, "amount must be positive")
    assert(private[self].balance >= amount, "not enough balance")

    private[self].balance = private[self].balance - amount
end

function BankAccount:getSnapshot()
    local data = private[self]

    -- 返回副本, 不返回 private 里的真实表。
    return {
        owner = data.owner,
        balance = data.balance
    }
end

function BankAccount:__tostring()
    local data = private[self]
    return "BankAccount(owner=" .. data.owner .. ", balance=" .. data.balance .. ")"
end

local account = BankAccount.new("Alice", 100)

print(account)
print("owner:", account:getOwner())
print("balance:", account:getBalance())

account:deposit(50)
account:withdraw(20)

print("after operations:", account)
print("account.owner 直接读不到:", account.owner)
print("account.balance 直接读不到:", account.balance)
print("getmetatable(account):", getmetatable(account))

local snapshot = account:getSnapshot()
snapshot.balance = 999999

print("修改 snapshot 不影响真实余额:", account:getBalance())

local ok, err = pcall(function()
    account.balance = 0
end)

print("直接写 balance 是否成功:", ok)
print("错误信息:", err)

-- 注意:
-- rawset(account, "balance", 0) 仍然可以绕过 __newindex。
-- Lua 的封装是 API 约束, 不是绝对安全沙箱。
