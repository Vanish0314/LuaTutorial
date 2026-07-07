--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 15:42:05
LastEditTime: 2026-07-07 16:07:21
--------------------------------------------------------------------------------
--]]
--[[
--------------------------------------------------------------------------------
Copyright (c) 2025 Vanishing Games. All Rights Reserved.
Author: VanishXiao
Date: 2026-07-07 15:42:05
LastEditTime: 2026-07-07 15:54:08
--------------------------------------------------------------------------------
--]]

-- 获取字符串长度
str = "abcdef四个汉字"
print(#str) -- 打印字符串长度
print("lua中一个汉字的长度为3")

print("-------------------------------")

--多行打印字符串
--1.转义
print("第一行\n第二行")

--2.多行语法
str =[[第一行
第二行
第三行]]
print(str)

print("-------------------------------")

--字符串拼接
print("第一段".."第二段")
str0 = 111
str1 = 222
print(str0..str1)

print("-------------------------------")

--字符串占位符
print(string.format("我今年%d岁了",18))
--%d: 数字
--%a: 字符
--%s: 字符

--转字符串
print(tostring(true))

--字符串方法
str = "aFVHGfadjsf"
print(string.upper(str))
print(str) --.upper不改变原字符串

print(string.find(str,"a")) -- 返回第一个匹配项， 第一个数字： 起始 第二个： 结束

print(string.gsub(str,"a","jsf")) -- 返回结果以及 修改次数
print(str) -- 原变量依旧不变

asc = string.byte(str,2) --转换ascii码
print(asc)
print(string.char(asc)) -- ascill码转string
