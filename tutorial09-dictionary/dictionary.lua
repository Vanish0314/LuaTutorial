dic = {1,nil}

dic.age = 22
dic.sex = "male"
dic.name = "unknown"
dic["name"] = "vanish"

printDic = function(dic)
    for i, v in pairs(dic) do
        print(i, v); --Lua 不保证键的顺序
    end
end

printDic(dic)

-- Delete
dic.sex = nil
print("================= After Delete =================")
printDic(dic)