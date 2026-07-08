-- 多变量赋值
a,b,c = 1,2
print(a)
print(b)
print(c)

a,b,c = 1,2,3,4,5,6
print(a)
print(b)
print(c)

-- 多返回值
function IReturnsALot()
    return a,b,c
end

print(IReturnsALot())