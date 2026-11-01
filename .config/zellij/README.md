# Zellij：稳定优先的渐进迁移计划

目标分工：**WezTerm tab 保留为更高一级的 workspace/session 容器；Zellij 管理
workspace 内部的 session、tab、pane 和 layout；shell 负责 alias、Readline 和 fzf。**
Alacritty 没有 WezTerm workspace tab 这一层，只负责终端窗口并承载 Zellij。
在每一步通过人工测试前，不删除 WezTerm 的备用能力，也不进入下一步。

当前版本：Zellij 0.45.1。`zellij setup --check` 已通过；这只证明配置能被解析，
不证明交互启动正常。

## 1. 已核实的现状

- `config/config.kdl` 同时启用自定义 shell、session serialization、自定义键和主题。
- 四个 layout 都直接加载 `zjstatus.wasm`；其中三个还运行 `sysstat.py`，无法在
  启动故障时隔离插件、权限和命令部件。
- Windows 上 `where zellij-shell.cmd`、`where zellij-session.cmd` 和
  `where zellij-sessionizer.cmd` 均找不到目标。
- `Share/scripts` 实际存在：
  - `zellij-shell.sh`、`zellij-session.sh`、`zellij-sessionizer.sh`
  - `lib/zellij_shell.py`、`lib/zellij_session.py`、`lib/zellij_sessionizer.py`
- 旧文档提到的 `Share/scripts/win/zellij-shell.cmd` 和
  `Share/scripts/arch/zellij-shell.cmd` 实际不存在。
- 旧文档说 WezTerm 已不再注入命令，但 `wezterm.lua` 仍有 `Alt-y/f/g`，平台分支
  也仍有 `Alt-c`。以实际配置为准。

因此，初始化卡住时至少有四类候选：默认配置以外的启动链、shell wrapper、
`zjstatus` 权限/加载、layout 中的命令部件。现在不预先认定唯一根因。

## 2. WezTerm → Zellij 迁移确认表

状态全部为**待确认**。原则是动作可以迁移，终端独有的文本与窗口能力不强行迁移。

| ID | WezTerm 当前能力 | 建议归宿 | 建议 / 需要确认的点 |
|---|---|---|---|
| M01 | `Ctrl-a` 同时被 WezTerm leader 和候选 Zellij prefix 使用 | 按上下文分流 | **建议 Zellij 内用 `Ctrl-a`**，释放 `Ctrl-Space` 给 Clink/Bash；WezTerm workspace 用直接键，避免两层 leader 同时抢占 |
| M02 | `Ctrl-Shift-t`、leader `c` 新建 tab | 两层共存 | `Ctrl-Shift-t` 保留为 WezTerm workspace；Zellij 内 leader `c` 新建内部 tab；Spawn 行为先经 P4 对比 |
| M03 | `Ctrl-Alt-h/l` 前/后 tab | WezTerm workspace | 原键保留切换 workspace；Zellij 内部 tab 建议用 leader `p/n`，避免同名键跨层抢焦点 |
| M04 | `Ctrl-Alt-H/L` 移动 tab | WezTerm workspace | 原键保留移动 workspace；Zellij 内部 `MoveTab` 另配键，不删除终端层能力 |
| M05 | leader `1..9` 跳转 tab | 按上下文分流 | Zellij 内跳内部 tab；Zellij 外才跳 WezTerm workspace。若检测不可靠则保留显式不同键，不做全局覆盖 |
| M06 | `Ctrl-Shift-Alt-w`、leader `Shift-7` 关闭 tab | 两层共存 | 前者关闭 WezTerm workspace，后者可作为 Zellij 内部关闭；必须实测关闭 workspace 后 session 是 detach 还是退出 |
| M07 | leader `-/s` 下拆，`\\/v` 右拆 | Zellij 内；WezTerm 外备用 | Zellij 内 `NewPane`；未启动 Zellij 时保留 WezTerm split |
| M08 | leader `h/j/k/l` 聚焦 pane | Zellij 内；WezTerm 外备用 | 按上下文门控；Neovim 边界导航另列后期工作 |
| M09 | leader `Shift-h/j/k/l` 调整 pane 大小 | Zellij 内；WezTerm 外备用 | 按上下文门控，并人工核对 Zellij 方向与步进 |
| M10 | leader `z` zoom | Zellij 内；WezTerm 外备用 | Zellij 内 fullscreen；外部保留 WezTerm zoom |
| M11 | leader `x` 关闭 pane | Zellij 内；WezTerm 外备用 | 按上下文门控；确认是否接受两者不同的关闭确认语义 |
| M12 | `Ctrl-Shift-Alt-l` 的自定义 split/zoom/focus 状态机 | 仅 WezTerm 外部备用 | 不迁入 Zellij；Zellij 内使用明确的 split / zoom / focus |
| M13 | leader `g` 在 WezTerm 新 tab 开 lazygit | P4 对比后决定 | 对比 `SpawnCommandInNewTab`、Zellij 内部 tab 和 floating `Run`，不预先认定哪种更快或更合适 |
| M14 | `Alt-y/f/g` 注入 yazi/fzf/lazygit；`Alt-c` 注入 tere | 从终端层移除 | 文本会注入 Neovim；fzf 归 shell，tere/yazi 手动启动；lazygit 入口由 M13 决定 |
| M15 | 新 OS 窗口、全屏、默认 cwd、初始 shell | WezTerm / Alacritty | 不迁移；Zellij 新 pane 的 shell 单独验证 |
| M16 | 搜索、复制模式、剪贴板、鼠标、QuickSelect URL/path | WezTerm / Alacritty | 不迁移；Zellij 不重复实现终端文本选择 |
| M17 | 在 Vim 中打开整个终端 scrollback | 两者按范围共存 | WezTerm 管终端 scrollback；Zellij `EditScrollback` 管单 pane，后期再验证 |
| M18 | tab title 格式化、底部 tab bar | 两层分别显示 | WezTerm tab 标题表示 workspace/session；Zellij tab/status 表示内部视图；单个 workspace 时仍可隐藏 WezTerm tab bar |
| M19 | `terminal-theme-switch` 外观状态 | 外部工具继续拥有状态 | WezTerm / Zellij / Alacritty 各自适配；Alacritty 支持加入 `Share/projs/terminal-theme-switch`，不写入 multiplexer |
| M20 | session、项目 layout、sessionizer、swap layout | Zellij 新增；WezTerm 负责承载 | 候选模型是一个 WezTerm workspace 承载一个 Zellij session，但是否默认如此由 P4/P6 实测决定 |
| M21 | WezTerm pane 键及 `unzoom_on_switch_pane` | 长期保留外部备用 | **仅在 Zellij 活跃时禁用/放行冲突的 WezTerm pane 键**；不静态删除外部 fallback |

目标层级为：

```text
OS window
└── WezTerm workspace tab（可运行 Spawn 命令，或承载一个 Zellij client）
    └── Zellij session
        └── Zellij tab
            └── Zellij pane
```

这只是候选容器模型，不预设 WezTerm 一定比 Zellij 快，也不预设每个 workspace 必须
永久绑定一个 session。Alacritty 没有 workspace tab 层，因此只能以一个 OS window
承载一个 client/session，不要求与 WezTerm 在这一层伪装成一致。

## 3. 阶段规则

1. 每个 Prompt 只做一阶段；上阶段人工检查未全部通过，不继续。
2. 每阶段只增加一个启动变量；P5/P6/P7 内部还有明确检查点，P4 只做对照实验。
3. 自动化只检查语法、路径和非交互命令。**是否卡住、键是否被截获、焦点与视觉
   状态是否正确，由用户在新窗口中物理验证。**
4. 测试一律使用独立 session 名；失败只 kill/delete 该测试 session，禁止
   `kill-all-sessions` / `delete-all-sessions`。
5. 失败后保留现场并报告：最后可见画面、是否接受键盘、是否产生进程/session、
   精确命令和错误文本。不要连续试多个修复。

---

## P0 — 只读基线与故障分流（难度：低）

```text
任务：只诊断 Zellij 0.45.1 初始化卡住，不修改任何仓库文件。

范围：
- C:\Users\User\Share\dotfiles\.config\zellij
- C:\Users\User\Share\scripts\zellij*
- C:\Users\User\Share\scripts\lib\zellij*
- C:\Users\User\Share\dotfiles\.config\wezterm\wezterm.lua

已确认：zellij setup --check 通过；Windows 上三个 zellij-*.cmd 入口均缺失。

请做：
1. 读取上述配置和脚本，列出默认启动实际经过的每一步。
2. 检查版本、配置路径、可执行文件解析和现有测试 session；不启动交互进程代替用户测试。
3. 给我两条分别在新 WezTerm 窗口执行的命令：
   A. zellij setup --clean（完全绕过自定义配置）
   B. 用独立 session 名启动当前配置。
4. 不清理我的现有 session，不运行 kill-all/delete-all。

人工检查：
- A 是否出现内置 UI 和可用 shell；能否输入、退出。
- B 最后停在哪一层；是黑屏、权限提示、空 pane，还是 shell 未出现。
- 两条路径的 session/process 状态有何差异。

停止条件：A 也卡住时，不改配置，先报告终端/Zellij 平台层症状。
交付：启动链图、最小区分结果、下一阶段的单一候选变量；不做修复。
```

## P1 — 隔离的最小配置（难度：低）

```text
任务：建立完全隔离的最小 Zellij 配置，不改 live config。

仅在 C:\Users\User\.temp\opencode\zellij-minimal 创建 config.kdl：
- default_shell "cmd.exe"
- default_layout "compact"（使用内置 compact，不加载仓库 layouts/default.kdl）
- session_serialization false
- serialize_pane_viewport false
- show_startup_tips false
- show_release_notes false
不得配置 zjstatus、自定义 keybind、Clink、主题联动或项目 layout。

自动检查：zellij setup --check，并显式传入该临时 config/config-dir。
人工启动命令必须同时显式传 --config-dir、--config 和独立 --session 名。

人工检查：
1. 30 秒内出现内置 compact UI 和 cmd prompt。
2. echo、dir、exit 可用；窗口不是只渲染但不接受输入。
3. 再开一次可重复；关闭后只清理该测试 session。

通过后才进入 P2；失败则保留临时配置和日志，不叠加其他改动。
```

## P2 — 将已验证的最小配置设为可用基线（难度：低）

```text
任务：把 P1 已人工通过的最小行为迁到 live config；不是直接复制原高级配置。

允许修改：.config/zellij/config/config.kdl。
必须先把当前完整配置保留为 config.full.kdl；不得覆盖已有 config.kdl.bak。
live 基线仍用 default_layout "compact"、cmd.exe、无自定义插件、无 serialization、
无自定义 keybind。原 layouts 和插件文件只保留，不删除。

自动检查：zellij setup --check；确认加载的是预期 config 文件。
人工检查：重复 P1 的全部测试，并额外打开第二个新 pane，确认仍是 cmd.exe。
回退：恢复 config.full.kdl 为 config.kdl；只清理本阶段测试 session。
交付：diff、检查结果和人工验证清单；不提前恢复 Clink 或 zjstatus。
```

## P3 — 只恢复 shell wrapper 与 Clink（难度：中）

```text
任务：在最小 Zellij 基线上恢复交互 shell，一次只改 shell 链。

范围：
- Share/scripts/win/zellij-shell.cmd（当前缺失）
- Share/scripts/zellij-shell.sh 和 lib/zellij_shell.py（尽量复用，不另写一套逻辑）
- live config.kdl 的 default_shell
Linux 对应入口可以补齐，但本阶段不得声称已在 Linux 验证。

先做非交互检查：where zellij-shell.cmd；用 -c 输出固定标记；验证参数和退出码。
再将 default_shell 改为已验证入口，不改 layout、keybind、插件。

人工检查：
1. 首个 pane 和新建 pane 都进入 Clink，而非普通 cmd 或空 pane。
2. Ctrl-r、Tab、Ctrl-Space、目录跳转和 alias 各测一次。
3. echo、exit、 pane 关闭都正常；连续启动两次结果一致。
4. 若 Clink 失败，直接 default_shell="cmd.exe" 回退，确认 Zellij 本身仍正常。

停止条件：shell 非交互检查失败时不改 Zellij 其他配置。
```

## P4 — WezTerm workspace / Spawn 与 Zellij 对照（难度：中）

```text
任务：只对比同一命令在 WezTerm 与 Zellij 中的生命周期和实际体验，不预设性能结论，
不修改 live keybind。

至少比较：
A. WezTerm SpawnCommandInNewTab 直接运行命令。
B. WezTerm workspace tab 中启动 shell / zellij-session。
C. Zellij 内部 tab 运行同一命令。
D. Zellij floating Run 运行同一命令（适用于 lazygit 等临时工具）。

使用相同的 cwd、环境、命令参数和窗口尺寸。可用 lazygit 作为交互命令，再用一个
确定退出的命令检查生命周期。性能只记录本机证据，不使用“ multiplexer 一定慢/快 ”
作为设计依据。

人工检查：
1. 从触发到可输入的时间、连续输出和 resize 是否流畅。
2. 命令退出后 tab/pane 是否关闭、是否留下 shell、session 是否仍可 attach。
3. cwd、PATH、alias 和非交互参数是否一致。
4. 搜索、选择、复制、scrollback 分别发生在哪一层。
5. 关闭 WezTerm workspace 时，内部 Zellij session 是 detach 保留还是被杀死。
6. 空闲和相同负载下的进程/内存只作同机对照，不跨条件跑分。

交付：A–D 对照表，以及 M02/M05/M06/M13/M20 的建议；未实测前不改默认 Spawn 策略。
```

## P5 — 核心 tab / pane 键与上下文门控（难度：中高）

```text
任务：按 P4 结论和已确认的 M01–M13 配置键位；保持 P2/P3 的启动链不变。
WezTerm workspace tab 键长期保留，不作为“重复功能”删除。

检查点 5A：prefix 与两层 tab。
- 按 M01 选择 prefix；若用 Ctrl-a，验证 Ctrl-a Ctrl-a 发送字面 Ctrl-a。
- WezTerm 的 Ctrl-Shift-t、Ctrl-Alt-h/l/H/L 继续管 workspace。
- Zellij 内 leader c/p/n/1..9 管内部 tab；关闭行为按 M06 实测结果配置。
- 人工验证后暂停，不立即加 pane 键。

检查点 5B：仅对 pane 键做上下文门控。
- Zellij 活跃：放行拆分、方向焦点、resize、zoom、关闭 pane 给 Zellij。
- Zellij 未活跃：同一组键继续执行原 WezTerm pane 动作。
- 只门控冲突的 pane 键，不能顺带禁用 workspace、复制、搜索、全屏等终端键。
- 不实现 M12 的 Zellij 版本，不碰 Neovim 导航，不静态删除 WezTerm fallback。

人工检查：
- 同一组 pane 键分别在 Zellij 内、外测试，动作归属可预测。
- 启动/退出/detach/attach 后检测状态能恢复，不出现永久禁用或永久截获。
- workspace 键在 Zellij 内仍工作；内部 tab 键不与 workspace 键混用。
- Ctrl-Space 仍到达 Clink/Bash（若确认使用 Ctrl-a prefix）。
- 拆分→聚焦→resize→zoom→还原→关闭形成完整可逆路径。

若进程检测不可靠，不猜测：保留显式不同键或手动模式开关，不做自动门控。
任何键不符就只回退本检查点的 keybind diff。
```

## P6 — session、简单 layout 与启动器（难度：中高）

```text
任务：在内置 UI 已稳定后恢复持久工作流；不得启用 zjstatus/sysstat。
结合 P4 结果验证 WezTerm workspace 与 Zellij session 的对应关系。

检查点 6A：只用 CLI 验证独立 session 的 detach、attach、关闭；不跑自定义脚本。
检查点 6B：把 default/project layout 改成无第三方插件的简单 layout，再测 user
layout；每个 layout 单独启动，确认 cwd、nvim/yazi 退出和 tab 切换。
检查点 6C：复用 zellij-session.sh + lib/zellij_session.py，补实际缺失的平台薄入口；
验证“不存在则创建、存在则 attach、目录参数设置 cwd、session 名合法化”。
检查点 6D：先只开 session_serialization；serialize_pane_viewport 保持 false。
验证 detach/attach 后，再单独测试 delete/resurrect；不把进程恢复当作已支持能力。

人工检查：
- 每个检查点独立通过后再继续。
- 不出现嵌套 Zellij；attach 不重复创建 tab。
- 同一 session 从第二个 WezTerm workspace attach 时行为符合 P4 结论。
- layout 不加载 zjstatus，不出现权限提示。
- 只删除本阶段专用测试 session。

若 serialization 引入卡住，单独关闭它并回退到 6C 已验证状态。
```

## P7 — sessionizer 与浮动工具（难度：高）

```text
任务：恢复 zellij-sessionizer 和 P4 选定的 lazygit 入口；不改 P5 键模型和 P6 基线。

范围：zellij-sessionizer.sh、lib/zellij_sessionizer.py、实际平台入口、对应 keybind。
先用 --dir 做确定性测试，再测 zoxide+fzf；不得一开始同时调两条路径。

人工检查：
1. --dir 已存在 session 时 switch，不新建嵌套客户端。
2. --dir 新目录时以 project layout 创建，cwd 正确。
3. fzf 取消不改变 session；空 zoxide 结果有明确回退。
4. lazygit 按 P4 选定方式打开/退出；若选 floating，必须回到原 pane 和 normal mode。
5. 两个同名目录的 session 冲突被报告；不得静默接到错误项目。

失败时停用对应 keybind，保留脚本和测试证据，不影响基础 session 使用。
```

## P8 — zjstatus，最后才加（难度：高）

```text
任务：最后恢复第三方 status；把插件加载、权限和 sysstat 分成两个检查点。

检查点 8A：只加载 zjstatus 的静态 mode/tab/session 显示，不含 command_sys。
- 保留 P6 简单 layout 的可回退副本。
- 用户物理处理权限提示；记录鼠标/键盘是否可聚焦，不把旧 issue 当作本机根因。
- 验证首次启动、第二次启动、detach/attach 和新 tab。

检查点 8B：仅 8A 稳定后加入 command_sys。
- 先独立运行 sysstat.py，核对输出、依赖和超时。
- 验证命令失败时 status 不阻塞输入；再检查 CPU/RAM/GPU 显示。

人工检查：状态栏与 pane frame 不遮输入，权限只询问预期次数，主题/颜色无卡死。
回退：8B 失败只移除 command_sys；8A 失败恢复无 zjstatus 的 P6 layout。
```

## P9 — 按上下文定稿与文档切换（难度：高）

```text
任务：仅在 M01–M21 已逐项确认且 P0–P8 均人工通过后，定稿两层职责。

允许修改 wezterm.lua、本 README 和已确认的关联配置。
- 保留 WezTerm workspace tab、Spawn、窗口和终端文本能力。
- 保留 Zellij 外的 WezTerm pane fallback；只在 Zellij 活跃时门控冲突 pane 键。
- 移除 Alt-y/f/g、Alt-c 文本注入；lazygit 使用 P4 选定的入口。
- 不静态删除整组 tab/pane 配置，不在本阶段同时重做 Alacritty、Bash/Clink 或 Neovim。

人工对照测试：
1. 同一组 pane 键在 Zellij 内归 Zellij、在外归 WezTerm，退出后状态恢复。
2. WezTerm workspace 键在 Zellij 内仍可用；内部 tab 键作用范围正确。
3. readline/Neovim 常用 Ctrl 键不被误截获；prefix 有明确发送字面量的方法。
4. 终端级复制、搜索、URL/path、全屏、新窗口仍工作。
5. 关闭 workspace、detach、重新 attach 后的 session 生命周期符合 P4/P6 结果。

交付：逐项映射的实测结果、最终职责表、回退 diff；将本文“未验证现状”更新为真实用法。
```

## 4. 明确暂缓

- Neovim `neolij.nvim` 边界导航与 `blink-cmp-zellij`：基础 multiplexer 稳定后另立阶段。
- viewport serialization、复杂 swap layout、tmux-fzf-links、translator 和自定义
  copy-mode：不属于最小可用迁移。
- 不为了让两边界面相似而在 Alacritty 实现 tab/pane；它们属于 Zellij，WezTerm
  workspace tab 这一层在 Alacritty 中用独立 OS window / session 表达。

## 5. 关联工作的实施状态

### Alacritty 与 terminal-theme-switch

已完成源码和本机部署：唯一共享 TOML、Windows/Linux 启动器、Alacritty dark/light
主题源、稳定运行时文件，以及 `refresh()` 同步。普通 `terminal-theme-switch cycle`
也会更新 Alacritty 主题文件。Alacritty 0.17.0 配置解析和主题工具单元测试已通过。

实际启动参数、共同键位、刻意保留的终端差异和 GUI 验收清单见
`.config/alacritty/README.md`。已打开窗口的主题热重载、Linux 启动和原始 Start Menu
shortcut 不视为已验证；shortcut 目前仍会绕过 wrapper。

### Clink / Bash 异构兼容

讨论方案见 `.config/bash/README.md`：继续共享 alias YAML，对齐 Readline/fzf 的
用户可见习惯，cmd/Lua 与 Bash 各保留薄实现。C0–C4 先处理启动保护，再迁移 alias
和键位；本轮没有重写 Bash 启动链，也不在 Zellij shell 基线验证期间并行修改它。
