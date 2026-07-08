# Lua 元表主流范式示例

这个目录放的是元表在实际 Lua 代码里的常见写法。每个 `.lua` 文件都是一个独立实验，可以单独运行。

运行方式:

```powershell
cd C:\Users\Admin\Desktop\WorkSpace\LuaTang\tutorial15-metatable\best-practices
lua run_all.lua
```

也可以单独运行:

```powershell
lua 02_class_instance.lua
```

## 文件说明

- `01_module_table.lua`: 模块表写法, 避免污染全局变量。
- `02_class_instance.lua`: `Class.__index = Class` 的对象范式。
- `03_prototype_inheritance.lua`: 原型继承, 实例 -> 子类 -> 父类。
- `04_default_config.lua`: 用 `__index` 做默认配置。
- `05_readonly_proxy.lua`: 只读代理表。
- `06_observable_proxy.lua`: 监听字段读写的代理表。
- `07_value_object_vector.lua`: 值对象和运算符重载。
- `08_private_data_weak_table.lua`: 弱表保存私有数据。
- `09_safe_metatable.lua`: 保护元表, 并用代理方式校验写入。
- `10_coding_style.lua`: 常见代码风格和编码规范。

核心原则:

```text
对象自己的字段 = 数据
元表里的 __xxx = 特殊操作的行为规则
table 存状态, metatable 定行为, module 组织命名空间, colon 传 self
```
