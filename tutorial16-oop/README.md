# tutorial16-oop

Lua 没有内置 `class` 关键字。Lua 的 OOP 通常由 `table + metatable + function` 组合出来。

这个目录展示三个最常用的 OOP 范式:

```text
封装: 隐藏数据, 暴露方法
继承: 复用父类方法, 子类可覆盖行为
多态: 不关心具体类型, 只关心对象是否支持同一组方法
```

运行全部示例:

```powershell
cd C:\Users\Admin\Desktop\WorkSpace\LuaTang\tutorial16-oop
lua run_all.lua
```

单独运行:

```powershell
lua 01_encapsulation.lua
lua 02_inheritance.lua
lua 03_polymorphism.lua
lua 04_oop_style_rules.lua
```

## Best Practice 总结

- 默认使用 `local`, 避免污染全局变量。
- 类表使用 `Class.__index = Class`。
- 构造函数常用 `Class.new(...)`, 不需要 `self`, 用点号。
- 实例方法需要 `self`, 用冒号定义和调用。
- 私有数据不要直接放在实例表上, 可用闭包或弱表保存。
- 继承不要做太深, 通常 1 到 2 层足够。
- 多态优先依赖方法协议, 不要到处判断具体类型。
- 元表是行为规则, 不要让元表魔法变得太隐式。
