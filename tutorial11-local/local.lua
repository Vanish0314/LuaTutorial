-- local & global
-- 不用 `local` 修饰就是 global

for i=1,2 do 
    global = "I'm global"
end

for i = 1,2 do
    local locale = "I'm locale"
end

print("global:"..global)
print("local:"..type(locale))