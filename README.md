# LuaTang

这个仓库已经按照提交历史整理成一组 Lua 入门教程。每一次提交对应一个章节目录，目录名使用 `tutorial0x` 风格的顺序编号，方便按历史演进逐章学习。

## 学习顺序

| 章节 | 来源提交 | 主题 | 示例文件 |
| --- | --- | --- | --- |
| [tutorial0x01-simple-variables](./tutorial0x01-simple-variables) | `ad3e78c` | 基础变量与 `type` | `variable.lua` |
| [tutorial0x02-string](./tutorial0x02-string) | `cd8905f` | 字符串长度、拼接、格式化和常用方法 | `StringOperation.lua` |
| [tutorial0x03-operator](./tutorial0x03-operator) | `d014913` | 算术、条件、逻辑运算符 | `Operator.lua` |
| [tutorial0x04-condition](./tutorial0x04-condition) | `db3dbdd` | `if / elseif / else` 条件分支 | `Condition.lua` |
| [tutorial0x05-loop](./tutorial0x05-loop) | `332af9a` | `while`、`repeat until`、`for` 循环 | `Loop.lua` |
| [tutorial0x06-function](./tutorial0x06-function) | `fae14a3` | 函数、返回值、变长参数、闭包 | `Function.lua` |
| [tutorial0x07-table-basic](./tutorial0x07-table-basic) | `498f87c` | table 数组基础与索引 | `Table.lua` |
| [tutorial0x08-pairs](./tutorial0x08-pairs) | `72393a6` | `ipairs` 和 `pairs` 遍历 | `pair.lua` |
| [tutorial0x09-dictionary](./tutorial0x09-dictionary) | `0b14023` | table 作为字典使用 | `dictionary.lua` |
| [tutorial0x10-class-in-lua](./tutorial0x10-class-in-lua) | `123e7f4` | Lua 中的对象写法与冒号语法糖 | `class.lua` |

## 运行方式

进入任意章节目录，使用 Lua 运行对应示例：

```bash
lua variable.lua
```

如果当前机器的 Lua 命令名称不同，请替换为本地可用的 Lua 解释器命令。

## 整理原则

- 保留每个提交当时的核心示例文件。
- 每个章节都可以独立打开阅读。
- 根目录只作为教程索引，不再混放单独示例文件。
