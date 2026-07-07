-- Lua 中没有OOP
-- 需要自己实现 OOP

Student = {
    -- 成员变量
    name = "unknown",
    age = 0,
    sex = "unknown",
    info,

    -- 成员函数
    GrowUp = function (student)
        student.age = student.age + 1
    end,

    ChangeName = function (student, newName)
        student.name = newName
    end
}

Student.GetInfo = function (student)
    return student.info
end

Student.GrowUp(Student)
Student.ChangeName(Student, "Tom")

print(Student.name) -- Tom
print(Student.age)  -- 1
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
    GrowUp = function (student)
        student.age = student.age + 1
    end,

    ChangeName = function (student, newName)
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