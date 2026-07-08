-- 一次运行本目录下的所有范式示例

local files = {
    "01_module_table.lua",
    "02_class_instance.lua",
    "03_prototype_inheritance.lua",
    "04_default_config.lua",
    "05_readonly_proxy.lua",
    "06_observable_proxy.lua",
    "07_value_object_vector.lua",
    "08_private_data_weak_table.lua",
    "09_safe_metatable.lua",
    "10_coding_style.lua"
}

for _, file in ipairs(files) do
    print("")
    print("##################################################")
    print("RUN " .. file)
    print("##################################################")
    dofile(file)
end
