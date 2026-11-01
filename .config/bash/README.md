# Clink / Bash：异构兼容与习惯迁移方案

本文件目前是讨论和实施边界，不表示 Bash 启动链已重写完。目标是让 Clink 与
Linux Bash 共用**数据、命令名称和键位语义**，而不是共用同一段可执行 shell 代码。

## 1. 复用现有资产

```text
.config/alias.yaml
.config/alias-scripts.yaml
        ├── Clink：clink_binding.lua → doskey / Lua
        └── Bash：aliases.bash → alias / function

.config/bash/_inputrc
        ├── 通用 Readline set/bind
        ├── Clink：clink-*、luafunc:fzf_*
        └── Bash：bind -x、fzf bash completion、可选 ble.sh
```

`Share/dotfiles.win/Scoop/clink/_inputrc` 当前已有 Clink fzf 功能；Bash 侧的
`fzf.bash`、`functions.bash` 和 `fzf-*.sh` 是另一平台实现。复杂功能只统一入口名称，
保留两个薄实现，不写一个同时解析 cmd 和 Bash 语法的兼容层。

## 2. 共享与分流的边界

| 内容 | 方案 |
|---|---|
| 简单 alias | 继续共享 YAML；含 `$*` 时由平台适配器生成 doskey 或 function |
| 复杂管道、重定向、平台路径 | 放入平台脚本，YAML 只保存统一命令名 |
| Readline 通用选项 | 可提取共享 `_inputrc` 片段 |
| `clink-select-complete`、`luafunc:*` | 仅 Clink |
| `bind -x`、Bash completion、ble.sh | 仅 Bash |
| `user_env.cmd` / `.bashrc` 环境初始化 | 平台分别维护，不强行数据化 `%VAR%` 与 `$VAR` |
| 历史、目录、fzf 功能 | 对齐用户可见键位与结果，底层允许不同 |

## 3. 键位习惯映射

| 习惯 | Clink 当前实现 | Bash 目标 | 建议 |
|---|---|---|---|
| 历史搜索 | Ctrl-R → `fzf_history` | fzf 或 Atuin | **优先 fzf Ctrl-R 与 Clink 对齐**；Atuin 不同时抢同一键 |
| 强制补全 | Ctrl-Space → `fzf_complete_force` | fzf/bash completion | 保留 Ctrl-Space；Zellij 推荐 Ctrl-A，避免截获 |
| Tab 选择补全 | `clink-select-complete` | ble.sh / fzf completion | 先验证 ble.sh，再决定是否保留；不假设无依赖等价 |
| 查询绑定 | Alt-B → `fzf_bindings` | Bash 自定义只读查询 | 后期实现，非启动必需 |
| 目录跳转 | Alt-D → `fzf_directory` | `bind -x` + fzf + zoxide/cd | 对齐行为，不复用 Lua |
| 文件 / 内容搜索 | `fzf-files.sh`、`fzf-ripgrep.sh` | 同名 Bash 命令 | 保持统一命令名，修正 Bash 函数命名漂移 |
| Ctrl-T / Alt-C | Clink 当前显式禁用 | Bash fzf 默认可能启用 | 初版保持两边都禁用，之后有需求再成对启用 |

## 4. 当前 Bash 债务，先修基础再谈完全对齐

1. 多个 `source` / `eval` 没有文件或命令存在性保护；MSYS、Git Bash、Linux 不应
   无条件加载 ble.sh、Atuin、fzf、zoxide 和 `~/.ghc`。
2. 非 Termux 就追加 Linux TeXLive PATH，会把 MSYS/Git Bash 误判成 Linux。
3. `MANPATH="${MANPATH}:MANPATH"` 末尾缺少 `$`，会产生字面量。
4. 绑定使用 `fzf-files` / `fzf-ripgrep`，函数文件却定义 `fzf_ripgrep` 等名称。
5. Atuin 与 fzf 初始化顺序会决定 Ctrl-R 所有者，必须显式选择而非依赖覆盖顺序。
6. `.bashrc` 中还有不少 Termux/Linux 时代环境与路径，需按实际使用逐项保留或删除，
   不做一次性批量清理。

## 5. 分阶段实施顺序

- **C0：行为清单。** 用户确认 Ctrl-R、Tab、Ctrl-Space、Alt-B/D、Ctrl-T/Alt-C 的
  目标语义；记录 MSYS、Git Bash、Linux 各自实际使用的功能。
- **C1：启动保护。** 只加命令/文件存在性检查，修正 MANPATH 和明显失效绑定；
  每种 Bash 分别物理启动，不引入新功能。
- **C2：alias 对齐。** 保留现有 YAML，逐项分类简单 alias 与平台脚本；验证含空格、
  `$*`、管道、路径和退出码，不重写公共格式。
- **C3：Readline / fzf。** 一次迁移一个键，明确 Ctrl-R 唯一所有者；Clink 与 Bash
  分别物理测试，不通过“配置看起来相同”验收。
- **C4：Linux 迁移。** 在未来 Linux 环境复测路径、剪贴板、fzf、历史、补全和
  中文输入；Windows 通过不代表 Linux 通过。

每一步独立回退。Zellij 的 P0–P9 与这里的 C0–C4 不并行修改同一 shell 启动链；
若正在验证 Zellij shell wrapper，先保持 Clink/Bash 基线不变。
