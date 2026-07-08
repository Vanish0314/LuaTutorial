--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 19:42:38
LastEditTime: 2026-07-08 17:19:29
--------------------------------------------------------------------------------
--]]
-- Lua 中没有OOP
-- 需要自己实现 OOP

Student = {
    -- 成员变量
    name = "unknown",
    age = 0,
    sex = "unknown",
    info,

    -- 成员函数
    GrowUp = function(student)
        student.age = student.age + 1
    end,

    ChangeName = function(student, newName)
        student.name = newName
    end
}

Student.GetInfo = function(student)
    return student.info
end

Student.GrowUp(Student)
Student.ChangeName(Student, "Tom")

print(Student.name)             -- Tom
print(Student.age)              -- 1
print(Student.GetInfo(Student)) -- info


-- 以上写法太麻烦了
-- 为了调用更加方便, Lua提供了一个语法糖

print("======================================")

SugerStudent = {
    -- 成员变量
    name = "unknown",
    age = 0,
    sex = "unknown",
    info = "Super Suger Girl",

    -- 成员函数
    GrowUp = function(student)
        student.age = student.age + 1
    end,

    ChangeName = function(student, newName)
        student.name = newName
    end
}

function SugerStudent:GetInfo()
    print(self.info) -- self 为默认传入的第一个参数
end

SugerStudent:ChangeName("Suger")
SugerStudent:GrowUp()
SugerStudent:GrowUp()
SugerStudent:GrowUp()


print(SugerStudent.name)
print(SugerStudent.age)
print(SugerStudent:GetInfo())
print(SugerStudent.GetInfo(SugerStudent))


-- 表的公共操作

print("======================================")

table1 = { { age = 1, name = "first" }, { age = 12, name = "second" } }
table2 = { age = 3, name = "table2" }

-- 1. 插入
print("插入前数量:" .. #table1)
table.insert(table1, table2)
for i, k in pairs(table1) do
    print("插入后:" .. i .. " name=" .. k.name.. " age="..k.age)
end

-- 2. 删除
print("删除了:"..table.remove(table1).name)
print("删除后数量:" .. #table1)
for i, k in pairs(table1) do
    print("删除后:" .. i .. " name=" .. k.name.. " age="..k.age)
end

-- 3. 排序
table.insert(table1, table2)
print("排序前:")
for i, k in pairs(table1) do
    print("排序前:" .. i .. " name=" .. k.name.. " age="..k.age)
end

table.sort(table1,function (a,b)
    if a.age > b.age then
        return true
        -- 不需要else return false. table.sort 的比较函数里，Lua 只关心返回值是不是`true`
    end
end)
print("排序后:")
for i, k in pairs(table1) do
    print("排序后:" .. i .. " name=" .. k.name.. " age="..k.age)
end