-- 09_safe_metatable.lua
-- 主流范式: 保护元表 + 用代理方式校验写入。
-- 重点:
-- 如果字段真实存在于对象自己身上, 再次写入不会触发 __newindex。
-- 因此需要强校验时, 常把真实数据放到 private 表里。

local private = setmetatable({}, {
    __mode = "k"
})

local Product = {}

Product.__index = function(self, key)
    local data = private[self]

    if key == "price" then
        return data.price
    end

    if key == "priceText" then
        return string.format("$%.2f", data.price)
    end

    return Product[key]
end

Product.__newindex = function(self, key, value)
    local data = private[self]

    if key == "price" then
        if type(value) ~= "number" or value < 0 then
            error("price must be a non-negative number", 2)
        end

        data.price = value
        return
    end

    error("unknown field: " .. tostring(key), 2)
end

Product.__metatable = "Product metatable is locked"

function Product.new(price)
    local instance = setmetatable({}, Product)
    private[instance] = {
        price = 0
    }
    instance.price = price
    return instance
end

function Product:discount(rate)
    assert(type(rate) == "number", "rate must be a number")
    assert(rate >= 0 and rate <= 1, "rate must be between 0 and 1")

    self.price = self.price * (1 - rate)
end

local product = Product.new(100)

print("price:", product.price)
print("priceText:", product.priceText)

product:discount(0.2)

print("discount 后 price:", product.price)
print("getmetatable(product):", getmetatable(product))

local ok1, err1 = pcall(function()
    product.price = -1
end)

print("非法 price 是否成功:", ok1)
print("错误信息:", err1)

local ok2, err2 = pcall(function()
    product.name = "Book"
end)

print("写未知字段是否成功:", ok2)
print("错误信息:", err2)

-- 规范:
-- 1. 用 __metatable 隐藏真实元表。
-- 2. 需要拦截每次写入时, 不要把被拦截字段 rawset 到对象自己身上。
-- 3. 在元方法内部访问真实数据时, 避免再次触发同一个元方法。
