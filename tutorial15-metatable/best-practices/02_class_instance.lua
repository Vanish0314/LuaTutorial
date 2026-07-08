-- 02_class_instance.lua
-- 主流范式: Class.__index = Class
-- 作用: 实例自己找不到方法时, 去类表里找。

local Account = {}
Account.__index = Account

function Account.new(owner, balance)
    local instance = {
        owner = owner,
        balance = balance or 0
    }

    setmetatable(instance, Account)
    return instance
end

function Account:deposit(amount)
    assert(amount > 0, "amount must be positive")
    self.balance = self.balance + amount
end

function Account:withdraw(amount)
    assert(amount > 0, "amount must be positive")
    assert(self.balance >= amount, "not enough balance")
    self.balance = self.balance - amount
end

function Account:getBalance()
    return self.balance
end

local account = Account.new("Tom", 100)

print("实例自己的 owner:", account.owner)
print("实例自己没有 deposit:", rawget(account, "deposit"))
print("account.deposit 通过 Account.__index 找到:", account.deposit)

account:deposit(50)
account:withdraw(20)

print("余额:", account:getBalance())

-- 规范:
-- 需要 self 的方法用冒号定义和调用: function Account:deposit(...)
-- 不需要 self 的函数用点: Account.new(...)
