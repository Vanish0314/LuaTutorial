-- #1 函数
print([[==================================
|============#1 函数=============|
==================================]])

print("-----------------------------")
print("1. 定义函数")
function funcA()
    print("定义函数方法A")
end
funcA()
print(funcA)

funcA = function()
    print("定义函数方法B")
end
funcA()
print(funcA)

print("-----------------------------")
print("2. 有参数的函数")
funcWithParm = function(para) --可以不指定参数
    print(para)
end
print("执行funcwithParm中...")
funcWithParm(funcA)
funcWithParm()
funcWithParm(1,2,3,"123") -- 个数不匹配时,补nil或者丢弃

print("-----------------------------")
print("3. 返回参数的函数")
funcReturnParm = function(input)
    return input --不需要声明, 只要return
end

funcReturnParms = function(input)
    return input,input,input -- 返回多个参数
end

print(funcReturnParm(nil))
print(funcReturnParms(nil))

rec1, rec2, rec3, rec4 = funcReturnParms(3)
print(rec1, rec2, rec3, rec4)

-- #2 函数类型
print([[==================================
|==========#2 函数类型===========|
==================================]])

print("函数类型就是 function")
print("funcReturnParms的类型是"..type(funcReturnParms))
-- #3 函数重载
print([[==================================
|==========#3 函数重载===========|
==================================]])

print("Lua 不支持函数重载, 默认调用最后一个声明的函数")
function reloadFunc()
    print("第一次声明, 无参数")
end

function reloadFunc(input)
    print("第二次声明, 有参数, 参数为类型:"..type(input))
end

reloadFunc() --希望调用重载一, 但实际使用的第二个
-- #4 变长参数
print([[==================================
|==========#4 变长参数===========|
==================================]])

variadicFunc = function(...)
    arg = {...} -- arg是一个`table`, 用于接收所有输入参数
    print(string.format("参数有%d个, 如下:",#arg))
    for i = 1, #arg do
        print(arg[i]) -- Lua中下标从1开始
    end
end

variadicFunc(1,"124",true,funcReturnParms,nil)
-- #5 函数嵌套
print([[==================================
|==========#5 函数嵌套===========|
==================================]])
nestFunc = function()
    print("I'm nestFunc")
    return function()
        print("I'm InnerFunc")
    end
end
nestFunc()()

func1 = function(firstPara)
    return function(secondPara)
        return firstPara + secondPara
    end
end
func2 = func1(12)
print(func2(4))
print(func1(12)(4))

-- #6 闭包机制
print([[==================================
|==========#6 闭包机制===========|
==================================]])
-- Lua 闭包不会有 C++ 引用捕获局部变量后的悬空问题
-- Lua 闭包真正要小心的是“共享同一个外部变量”
local function section(title)
    print("")
    print("==== " .. title .. " ====")
end

section("1. A Lua closure keeps the local variable alive")

local function makeCounter()
    local count = 0

    return function()
        count = count + 1
        return count
    end
end

local counter = makeCounter()

print(counter())
print(counter())
print(counter())

section("2. Two closures can share the same captured variable")

local function makeTwoFunctions()
    local value = 0

    local addOne = function()
        value = value + 1
        return value
    end

    local addTen = function()
        value = value + 10
        return value
    end

    return addOne, addTen
end

local addOne, addTen = makeTwoFunctions()

print(addOne())
print(addOne())
print(addTen())
print(addOne())

section("3. Each call creates a different captured variable")

local counterA = makeCounter()
local counterB = makeCounter()

print("A", counterA())
print("A", counterA())
print("B", counterB())
print("B", counterB())
print("A", counterA())

section("4. Capturing a table means sharing the same mutable object")

local function makeTableReader(t)
    return function()
        return t.name
    end
end

local user = { name = "Alice" }
local readName = makeTableReader(user)

print(readName())
user.name = "Bob"
print(readName())
