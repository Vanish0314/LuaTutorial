-- 一次运行 tutorial16-oop 下的所有 OOP 示例

local files = {
    "01_encapsulation.lua",
    "02_inheritance.lua",
    "03_polymorphism.lua",
    "04_oop_style_rules.lua"
}

for _, file in ipairs(files) do
    print("")
    print("##################################################")
    print("RUN " .. file)
    print("##################################################")
    dofile(file)
end
