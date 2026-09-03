# TablePlus 插件使用教程

> 适用项目：BookManagerSystem（Godot 4.7 + C#）
> 插件版本：TablePlus v1.0（作者 mib_）
> 插件实际位置：`.addons/table-plus-611c0c27e5b5079db1ae5b19db46b987ff8b6dbb/addons/table_plus/`

---

## 目录

1. [插件简介](#1-插件简介)
2. [目录结构导读](#2-目录结构导读)
3. [安装与启用（关键前置步骤）](#3-安装与启用关键前置步骤)
4. [快速上手](#4-快速上手)
5. [核心概念与数据模型](#5-核心概念与数据模型)
6. [TablePlus 节点配置属性详解](#6-tableplus-节点配置属性详解)
7. [事件与信号](#7-事件与信号)
8. [交互：排序与点击](#8-交互排序与点击)
9. [主题定制（TablePlusTheme）](#9-主题定制tableplustheme)
10. [C# 项目中使用（本项目为 C#）](#10-c-项目中使用本项目为-c)
11. [完整示例（覆盖全部单元格类型）](#11-完整示例覆盖全部单元格类型)
12. [常见问题与注意事项](#12-常见问题与注意事项)
13. [API 速查表](#13-api-速查表)

---

## 1. 插件简介

**TablePlus** 是一个 Godot 4 的表格/数据表 UI 插件，提供类似电子表格的展示能力，核心特性：

- 通过 **自定义节点 `TablePlus`**（继承 `Control`）快速搭建表格
- **7 种单元格类型**：文本、数字、货币、百分比、日期、布尔值、进度条
- **表头点击排序**（升序 / 降序 / 取消），可逐列配置是否可排序
- 斑马纹背景、行列分割线、行高/表头高、间距等细粒度外观控制
- 完整可定制的主题资源 `TablePlusTheme`（自带 dark / warm 两套主题）
- 内置滚动条（自动显示 / 常显 / 隐藏），支持鼠标滚轮
- 行/单元格两级交互模式，配套行点击、单元格点击等信号
- 编辑器内可通过 `preview_data` 实时预览效果（无需运行项目）

> ⚠️ **重要说明**：当前插件源码位于项目 `.addons/` 目录下，**尚未安装到标准插件路径，也未在编辑器中启用**。请务必先阅读第 3 节完成安装启用，否则编辑器里找不到 `TablePlus` 节点。

---

## 2. 目录结构导读

插件完整路径为：

```
.addons/table-plus-611c0c27e5b5079db1ae5b19db46b987ff8b6dbb/addons/table_plus/
├── plugin.cfg                  # 插件声明（名称、作者、版本）
├── plugin.gd                   # EditorPlugin：向编辑器注册 "TablePlus" 自定义节点
├── table_plus.gd               # 主节点脚本（class 无显式名，节点类型为 TablePlus）
├── core/
│   ├── table_globals.gd        # 全局枚举：CellType / SortState / OverflowMode
│   ├── table_plus_theme.gd     # TablePlusTheme 主题资源类
│   ├── table_root/             # TableRoot：表格核心引擎（内部实现，一般不用直接碰）
│   │   └── table_root.gd
│   ├── table_header/           # 表头实现
│   │   ├── table_header.gd
│   │   ├── table_header_cell.gd
│   │   └── table_header_cell_resource.gd   # ★ 表头配置资源（需自行创建）
│   ├── table_row/              # 表格行实现（TableRow）
│   │   └── table_row.gd
│   └── table_cell/             # 单元格实现（TableCell 基类 + 7 种派生类型）
│       ├── table_cell.gd                # 抽象基类
│       ├── table_cell_factory.gd        # 根据类型创建单元格的工厂
│       ├── text_sheet_cell/             # 文本单元格 TextTableCell
│       ├── number_sheet_cell/           # 数字单元格 NumberTableCell
│       ├── currency_sheet_cell/         # 货币单元格 CurrencyTableCell
│       ├── percentage_sheet_cell/       # 百分比单元格 PercentageTableCell
│       ├── date_sheet_cell/             # 日期单元格 DateTableCell
│       ├── boolean_sheet_cell/          # 布尔单元格 BooleanTableCell
│       └── progress_sheet_cell/         # 进度条单元格 ProgressTableCell
├── examples/
│   ├── table_plus_example.tscn          # ★ 官方示例场景（可直接运行）
│   └── table_plus_example.gd
├── icons/                     # 图标（布尔勾叉、排序箭头）
└── themes/
	├── dark_theme.tres        # 深色主题
	└── warm_theme.tres        # 暖色主题
```

**使用插件只需关注三个入口**：

| 入口 | 作用 |
|---|---|
| `table_plus.gd`（TablePlus 节点） | 在场景中放置的根节点，暴露全部配置项 |
| `TableHeaderCellResource` | 定义每一列的表头（列名、类型、宽度、是否可排序等） |
| `TablePlusTheme` | 整体外观主题资源 |

`TableRoot / TableRow / TableCell / TableCellFactory` 等由插件内部使用，一般无需直接操作。

---

## 3. 安装与启用（关键前置步骤）

### 3.1 为什么需要这一步

Godot 只会在 **`res://addons/*/plugin.cfg`** 下发现编辑器插件。当前插件在 `.addons/`（插件管理器的下载缓存目录），且插件内部代码硬编码引用了 `res://addons/table_plus/...`（例如 `boolean_sheet_cell.gd` 中加载 `res://addons/table_plus/icons/true.svg`）。

因此必须把插件源码放到标准路径 `res://addons/table_plus/`。**二选一**：

**方式 A：符号链接（推荐，不复制文件）**

Windows 下用 Git Bash / 终端执行：

```bash
cd "D:/Users/xxbaozhen/Projects/GoDot Projects/BookManagerSystem"
# 使用目录联接（junction），无需管理员权限
cmd //c "mklink /J addons .addons\\table-plus-611c0c27e5b5079db1ae5b19db46b987ff8b6dbb\\addons\\table_plus"
```

或直接复制（简单但会产生两份文件）：

```bash
mkdir -p addons
cp -r ".addons/table-plus-611c0c27e5b5079db1ae5b19db46b987ff8b6dbb/addons/table_plus" addons/
```

> 若项目使用了 gd-plug 等插件管理器，也可直接在 Godot 中运行 `plug install`（本仓库当前没有 `plug.gd`，大概率是手动放置的）。

### 3.2 在编辑器中启用插件

1. 重新打开 Godot 项目（让编辑器重新扫描 `addons/`）
2. 菜单 **项目 → 项目设置 → 插件（Plugins）** 选项卡
3. 找到 **TablePlus**，把状态从 **Inactive** 切换为 **Active**
4. 启用后，编辑器会注册自定义节点类型 `TablePlus`

### 3.3 验证是否成功

- 在场景中右键 **添加节点（Add Node）**，搜索框输入 `TablePlus`，应出现该节点
- 选中该节点后，Inspector 中应出现大量以 `Title Settings`、`Header Settings`、`Row Settings` 等分组开头的属性

---

## 4. 快速上手

### 4.1 方式一：编辑器可视化搭建（推荐）

1. 在场景中创建 **TablePlus** 节点（见 3.3），调整其 `Rect` 尺寸（如 800×400）
2. **配置表头**：选中节点，在 Inspector 中找到 `Header Settings → Headers`（类型为 `Array[TableHeaderCellResource]`）：
   - 展开数组，`Add Element` 添加一列
   - 点击元素右侧新建资源（New TableHeaderCellResource），或直接在行内展开编辑
   - 每个表头资源配置：`id`（唯一）、`title`（列标题）、`type`（单元格类型）、`width_ratio`（列宽比例）等
3. **配置预览数据**：在 `Row Settings → Preview Settings → Preview Data` 中，按列顺序填入 `Array[Array]`，编辑器内即时预览效果
4. **调整外观**：设置 `headers_height`、`row_height`、分割线可见性、各单元格格式化参数等
5. 按 F5 运行，在代码里调用 `set_data()` 注入真实数据（见 4.2 / 第 5 节）

### 4.2 方式二：代码动态填充数据

在运行时，通过 `set_data()` 注入数据（GDScript 示例，C# 见第 10 节）：

```gdscript
extends Control

func _ready() -> void:
	$TablePlus.set_data([
		["1001", "三体", 9.2, 59.9, "2024-01-01", true, 0.85],
		["1002", "活着", 9.4, 35.0, "2024-02-15", false, 0.65],
	] as Array[Array])
```

> 表头（headers）决定了列数与每列类型；`set_data` 传入的每一行数组元素顺序必须与表头一一对应。

### 4.3 方式三：直接运行官方示例

插件自带示例场景：

- 路径：`res://addons/table_plus/examples/table_plus_example.tscn`
- 方法：在文件系统面板双击打开该场景，直接运行（F6 运行当前场景）
- 演示内容：3 列表头（ID / NAME / Introduction，含宽度比、对齐、不可排序列）+ 若干行数据 + 自定义主题

示例脚本 `table_plus_example.gd` 中还演示了 `row_clicked` / `cell_clicked` 信号的使用：

```gdscript
$TablePlus.row_clicked.connect(func(row_index: int, row: TableRow):
	print("Clicked row index: ", row_index, ", row: ", row)
)
$TablePlus.cell_clicked.connect(func(row_index: int, column_index: int, cell: TableCell):
	print("Clicked cell at row ", row_index, ", column ", column_index, ": ", cell.content)
)
```

---

## 5. 核心概念与数据模型

### 5.1 表头 headers：`Array[TableHeaderCellResource]`

每个 `TableHeaderCellResource` 定义一列，可用属性：

| 属性 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `id` | String | `""` | 列唯一标识（重复会报错，见第 12 节） |
| `title` | String | `"title"` | 列标题文本 |
| `type` | `TableGlobals.CellType` | `TEXT` | 该列单元格类型，决定渲染与数据格式 |
| `width_ratio` | float | `1.0` | 列宽比例（同一行内按比例分配宽度） |
| `sortable` | bool | `true` | 是否允许点击表头排序 |
| `sort_state` | `TableGlobals.SortState` | `NONE` | 初始排序状态 |
| `overflow_mode` | `TableGlobals.OverflowMode` | `CLIP` | 内容溢出处理：裁剪 / 省略号 |
| `title_alignment` | HorizontalAlignment | LEFT | 标题对齐 |
| `content_horizontal_alignment` | HorizontalAlignment | LEFT | 单元格内容水平对齐 |
| `content_vertical_alignment` | VerticalAlignment | CENTER | 单元格内容垂直对齐 |

**在编辑器中创建方式**：文件系统面板 → 右键 → **新建资源（New Resource）→ TableHeaderCellResource**，保存后拖入 `headers` 数组；或直接在 Inspector 中新建内联子资源。

### 5.2 数据 data：`Array[Array]`

- 运行时数据，通过 `table_plus.set_data(data)` 注入
- 结构：外层数组 = 行，内层数组 = 该行的各列值
- 每个单元格值的格式取决于对应表头列的 `type`（见 5.4）
- ⚠️ 行为差异：
  - **编辑器内**调用 `set_data()` 是**无效的**（`TableRoot.set_data` 内部有 `if Engine.is_editor_hint(): return`）
  - 编辑器预览请用 `preview_data`；**运行时**才用 `set_data()`
- 数据更新后表格自动重建行；重复调用 `set_data()` 会替换全部数据

### 5.3 编辑器预览 preview_data：`Array[Array]`

- 仅编辑器生效（运行时调用会被忽略）
- 作用：不运行项目即可在编辑器中看到表格长什么样，方便调样式

### 5.4 单元格类型与数据格式（重点）

| 类型 | 枚举值 | 接受的输入 | 显示效果示例 | 补充说明 |
|---|---|---|---|---|
| **文本** TEXT | `0` | 任意（转字符串） | `hello` | 支持溢出省略号 |
| **数字** NUMBER | `1` | int / float / 数字字符串 | `1,234.56` | 可配小数位、千分位/万分位、舍入模式 |
| **货币** CURRENCY | `2` | int / float / 数字字符串 | `$1,234.56` | 符号前缀 + 千分位，可配小数位、舍入 |
| **百分比** PERCENTAGE | `3` | 小数（0~1 的分数） | `12.34%` | **输入是分数**，内部 ×100 后加 `%` |
| **日期** DATE | `4` | 日期字符串 | `2024-12-31` | 兼容多种分隔符与紧凑格式（见下） |
| **布尔** BOOLEAN | `5` | bool / int / float / 特定字符串 | ✔ / ✘ 图标 | 无法识别的字符串会隐藏图标 |
| **进度条** PROGRESS | `6` | 数值 0~100 | 进度条 + 百分比 | 底层是 `ProgressBar`（min 0 / max 100） |

**数字/货币/百分比的格式化参数**（在 TablePlus 节点 Inspector 中配置，见第 6 节）：

- 小数位 `decimal_places` / `decimals`
- 分隔符 `DelimiterType`：`NONE`（无）/ `THOUSAND`（千分位 `,`）/ `TEN_THOUSAND`（万分位 `,`）
- 舍入模式 `RoundMode`：`ROUND`（四舍五入）/ `FLOOR`（向下取整）/ `CEIL`（向上取整）

**日期格式 `DateTableCell.DateFormat`**（9 种）：

| 枚举 | 显示 | 枚举 | 显示 |
|---|---|---|---|
| `YYYY_MM_DD` | `1970-12-31` | `YYYY_MM_DD_SLASH` | `1970/12/31` |
| `DD_MM_YYYY` | `31-12-1970` | `MM_DD_YYYY_SLASH` | `12/31/1970` |
| `MM_DD_YYYY` | `12-31-1970` | `DD_MM_YYYY_SLASH` | `31/12/1970` |
| `YYYY_MM_DD_DOT` | `1970.12.31` | `MM_DD_YYYY_DOT` | `12.31.1970` |
| | | `DD_MM_YYYY_DOT` | `31.12.1970` |

日期输入兼容：`2024-12-31`、`2024/12/31`、`31.12.2024`、紧凑格式 `20241231`，以及带时间部分（如 `2024-12-31 08:00` 或含 `T`）的字符串（自动截断时间）。

**布尔输入**：`true/false`（bool）、`1/0`（int/float）、字符串 `"True"/"true"/"T"/"t"/"1"/"1.0"` 与 `"False"/"false"/"F"/"f"/"0"/"0.0"`；其他字符串视为无效，图标隐藏。

---

## 6. TablePlus 节点配置属性详解

以下是 Inspector 中全部可配置属性（按分组）：

### Title Settings（标题）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `title_visible` | bool | `true` | 是否显示顶部标题 |
| `title_text` | String | `"Title"` | 标题文本 |
| `title_alignment` | HorizontalAlignment | LEFT | 标题对齐方式 |

### Header Settings（表头）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `headers` | Array[TableHeaderCellResource] | `[]` | 列定义（见 5.1） |
| `headers_height` | float | `50.0` | 表头行高 |
| `headers_vertical_separator_visible` | bool | `true` | 表头列间垂直分割线 |
| `headers_horizontal_separator_visible` | bool | `true` | 表头下方水平分割线 |
| `headers_horizontal_separators_offset` | float | `0.0` | 表头水平分割线 Y 偏移 |

### Row Settings（行）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `row_height` | float | `50.0` | 数据行高 |
| `rows_vertical_separators_visible` | bool | `true` | 数据行垂直分割线 |
| `rows_horizontal_separators_visible` | bool | `true` | 数据行水平分割线（末行自动隐藏） |
| `rows_horizontal_separators_offset` | float | `0.0` | 行水平分割线 Y 偏移 |

### Preview Settings（预览，编辑器专用）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `preview_data` | Array[Array] | `[]` | 编辑器内预览数据（运行时忽略） |

### Cell Settings（单元格格式化）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `number_cell_decimal_places` | int | `0` | 数字小数位 |
| `number_cell_delimiter_type` | `DelimiterType` | `NONE` | 数字分隔符（千分位/万分位） |
| `number_cell_round_mode` | `RoundMode` | `ROUND` | 数字舍入 |
| `currency_cell_decimal_places` | int | `1` | 货币小数位 |
| `currency_cell_round_mode` | `RoundMode` | `ROUND` | 货币舍入 |
| `currency_cell_currency_symbol` | String | `"$"` | 货币符号（如 `¥`） |
| `percentage_cell_decimal_places` | int | `0` | 百分比小数位 |
| `percentage_cell_round_mode` | `RoundMode` | `ROUND` | 百分比舍入 |
| `date_cell_display_format` | `DateFormat` | `YYYY_MM_DD` | 日期显示格式 |
| `progress_cell_fill_mode` | `ProgressBar.FillMode` | `FILL_BEGIN_TO_END` | 进度条填充方向 |
| `progress_cell_show_percentage` | bool | `true` | 进度条是否显示百分比文字 |

### Scroll Bar Settings（滚动条）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `scroll_bar_visible` | `ScrollbarVisibility` | `Auto` | Auto（内容超出才显示）/ AlwaysShow / NeverShow |
| `scroll_bar_custom_step` | float | `10.0` | 鼠标滚轮单步滚动距离 |

### Separation（间距）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `title_header_separation` | float | `0.0` | 标题与表头间距 |
| `header_rows_separation` | float | `0.0` | 表头与数据区间距 |
| `content_scroll_bar_separation` | float | `0.0` | 内容与滚动条间距 |
| `line_spacing` | float | `0.0` | 数据行间距 |

### Interaction Settings（交互）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `interaction_mode` | `InteractionMode` | `Row` | `Row`：整行响应点击；`Cell`：单元格各自响应点击 |

### Theme Settings（主题）

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `custom_theme` | `TablePlusTheme` | 自动创建 | 指定主题资源（见第 9 节） |

---

## 7. 事件与信号

`TablePlus` 节点提供 5 个信号：

| 信号 | 参数 | 触发时机 |
|---|---|---|
| `row_clicked` | `(row_index: int, row: TableRow)` | 点击某一行（Row 交互模式） |
| `row_mouse_entered` | `(row_index: int, row: TableRow)` | 鼠标进入某一行 |
| `row_mouse_exited` | `(row_index: int, row: TableRow)` | 鼠标离开某一行 |
| `cell_clicked` | `(row_index: int, column_index: int, cell: TableCell)` | 点击某个单元格（Cell 交互模式） |
| `export_data_changed` | `(key: String, value: Variant)` | 任一导出配置属性被修改时（编辑器/工具脚本可用） |

> 说明：
> - `row_clicked` 与 `cell_clicked` 取决于 `interaction_mode`：
>   - `Row` 模式：整行可点，触发 `row_clicked`（单元格不拦截鼠标）
>   - `Cell` 模式：单元格可点，触发 `cell_clicked`
> - `TableRoot`（内部引擎）也暴露同样 4 个交互信号，一般用 `TablePlus` 的信号即可。
> - 通过 `cell.content` 可读取单元格原始值；`cell.get_content_control()` 可拿到显示控件（Label/进度条等）。

---

## 8. 交互：排序与点击

### 8.1 表头排序

- 点击可排序列的表头（`sortable = true`），排序状态循环：**无排序 → 升序（↑）→ 降序（↓）→ 无排序**
- 排序时其他列的高亮状态会被清除，同一时刻只有一列处于排序中
- 排序基于各单元格类型的 `compare_values`（数字列按数值比，日期列按日期比，布尔列有特殊规则等）
- 数据排序后表格自动重建

### 8.2 行 / 单元格点击

- 交互模式见第 6 节 `interaction_mode`
- 配合第 7 节信号即可实现「点行打开详情」「点单元格编辑」等业务逻辑

---

## 9. 主题定制（TablePlusTheme）

### 9.1 使用自带主题

```gdscript
# 在场景中给 TablePlus.custom_theme 赋值
$TablePlus.custom_theme = load("res://addons/table_plus/themes/dark_theme.tres")
# 或 warm_theme.tres
```

### 9.2 创建自定义主题

1. 文件系统面板 → 右键 → **新建资源（New Resource）→ TablePlusTheme**，保存为 `.tres`
2. 打开资源，按分组配置：

| 分组 | 主要属性 |
|---|---|
| Title | `title_font` / `title_font_size`（36）/ `title_font_color` |
| Header | `header_background_stylebox` / `header_vertical_separator_stylebox` / `header_horizontal_separator_stylebox` |
| Header Cell | `header_cell_font` / `header_cell_font_size`（16）/ `header_cell_font_color` / `header_cell_background_stylebox` / `header_cell_asc_button_texture` / `header_cell_desc_button_texture` |
| Row | `row_enable_zebra_stripes`（默认 true）/ `row_background_styleboxs`（Array[StyleBox]，斑马纹交替色）/ `row_hover_background_stylebox` / `row_vertical_separator_stylebox` / `row_horizontal_separator_stylebox` |
| Row Cell | `row_cell_font` / `row_cell_font_size`（16）/ `row_cell_font_color` / `row_cell_background_stylebox` / `row_cell_hover_background_stylebox` |
| Cell → 各子分组 | 每种单元格类型的 `*_cell_background_stylebox` 与 `*_cell_hover_background_stylebox`（置空/`StyleBoxEmpty` 则回退到行级样式） |
| Boolean Cell | `boolean_cell_true_icon` / `boolean_cell_false_icon` |
| Progress Cell | 进度条背景/填充 StyleBox、字体颜色/描边/字号 |
| Scroll Bar | 增减按钮图标（increment/decrement 三态）、滚动条样式（scroll / grabber 三态）、内边距常量 |

3. 把资源拖到 TablePlus 节点的 `custom_theme` 属性上

> 主题是 `Resource`，可多表共享；修改主题资源时已连接该主题的表格会通过 `changed` 信号自动刷新。

---

## 10. C# 项目中使用（本项目为 C#）

本项目是 **Godot 4.7 + C#**，而 TablePlus 是纯 GDScript 插件。C# 侧没有强类型封装，需要通过 `Call` / `Set` / `Connect` 与 GDScript 互操作。

### 10.1 推荐姿势：表头在编辑器配置，运行时只注入数据

在场景中创建 `TablePlus` 节点，把表头、主题、预览数据都在 Inspector 里配好；C# 代码只负责填数据 + 接信号：

```csharp
using Godot;

public partial class BookListView : Control
{
	private Control _table;

	public override void _Ready()
	{
		_table = GetNode<Control>("TablePlus");

		// 连接信号（参数顺序与 GDScript 信号一致）
		_table.Connect("row_clicked",
			Callable.From<int, GodotObject>((rowIndex, row) =>
				GD.Print($"点击了第 {rowIndex} 行")));

		_table.Connect("cell_clicked",
			Callable.From<int, int, GodotObject>((r, c, cell) =>
				GD.Print($"单元格({r},{c}) = {cell.Get("content")}")));

		// 注入数据：外层行数组，内层列数组，顺序与表头一一对应
		var data = new Godot.Collections.Array
		{
			new Godot.Collections.Array { "1001", "三体", 9.2, 59.9, "2024-01-01", true, 0.85 },
			new Godot.Collections.Array { "1002", "活着", 9.4, 35.0, "2024-02-15", false, 0.65 },
		};
		_table.Call("set_data", data);   // 等价于 _table.Set("data", data)
	}
}
```

### 10.2 纯 C# 动态创建表头（可选进阶）

```csharp
var headerScript = GD.Load<Script>(
	"res://addons/table_plus/core/table_header/table_header_cell_resource.gd");

Resource MakeHeader(string id, string title, int type, float ratio = 1.0f)
{
	var h = new Resource();
	h.SetScript(headerScript);
	h.Set("id", id);
	h.Set("title", title);
	h.Set("type", type);        // 0..6 对应 TableGlobals.CellType
	h.Set("width_ratio", ratio);
	return h;
}

var headers = new Godot.Collections.Array
{
	MakeHeader("id",   "ID",    0, 0.8f),   // TEXT
	MakeHeader("name", "书名",  0, 2.0f),   // TEXT
	MakeHeader("score","评分",  1, 1.0f),   // NUMBER
	MakeHeader("price","价格",  2, 1.0f),   // CURRENCY
	MakeHeader("date", "上架",  4, 1.2f),   // DATE
	MakeHeader("avail","在售",  5, 0.8f),   // BOOLEAN
	MakeHeader("pct",  "售出",  3, 1.0f),   // PERCENTAGE
};
_table.Set("headers", headers);
```

> 在 C# 中读取单元格内容：`cell.Get("content")`（`content` 是 `TableCell` 的公开属性）。
> 注意 `Resource.SetScript` 依赖插件已安装到 `res://addons/table_plus/`（见第 3 节）。

---

## 11. 完整示例（覆盖全部单元格类型）

场景结构：

```
BookListView (Control)
└── TablePlus                     # 节点，配好如下属性
```

**Inspector 配置（表头 headers）**：

| id | title | type | width_ratio | sortable | 其他 |
|---|---|---|---|---|---|
| `id` | ID | TEXT | 0.8 | ✓ | content_horizontal_alignment = CENTER |
| `name` | 书名 | TEXT | 2.5 | ✓ | |
| `score` | 评分 | NUMBER | 1.0 | ✓ | `number_cell_decimal_places = 1` |
| `price` | 价格 | CURRENCY | 1.2 | ✓ | `currency_cell_currency_symbol = "¥"`, decimal_places = 2 |
| `stock` | 库存 | NUMBER | 1.0 | ✓ | `number_cell_delimiter_type = THOUSAND` |
| `date` | 上架日期 | DATE | 1.3 | ✓ | `date_cell_display_format = YYYY_MM_DD` |
| `onsale` | 在售 | BOOLEAN | 0.8 | ✓ | content_horizontal_alignment = CENTER |
| `sold` | 售出比例 | PROGRESS | 1.5 | ✓ | |
| `desc` | 简介 | TEXT | 3.0 | ✗（不可排序） | overflow_mode = ELLIPSIS |

**运行时数据（GDScript）**：

```gdscript
func _ready() -> void:
	$TablePlus.set_data([
		["1001", "三体",          9.2,  59.9, 12000, "2024-01-01", true,  0.85, "地球往事三部曲，雨果奖获奖作品"],
		["1002", "活着",          9.4,  35.0,  8300, "2024-02-15", true,  0.62, "余华代表作"],
		["1003", "百年孤独",      9.1,  55.5,  4200, "2023/12/20", false, 0.48, "加西亚·马尔克斯，魔幻现实主义经典"],
		["1004", "小王子",        9.0,  25.8, 21000, "31.12.2024", true,  0.91, "圣埃克苏佩里"],
		["1005", "时间简史",      8.8,  68.0,  1500, "20240105",   true,  0.30, "史蒂芬·霍金"],
	] as Array[Array])
```

**C# 版本（与上面等价）**：见第 10.1 节写法。

---

## 12. 常见问题与注意事项

### 12.1 编辑器里找不到 TablePlus 节点
插件尚未安装/启用。按第 3 节操作：确认 `addons/table_plus/plugin.cfg` 存在 → 项目设置 → 插件 → 启用 TablePlus → 重启编辑器。

### 12.2 运行时表格是空的 / set_data 没生效
`set_data()` 在**编辑器内是空操作**（源码 `TableRoot.set_data` 中有 `if Engine.is_editor_hint(): return`）。请确认：
- 是在**运行态**（`_ready()` 等）调用的
- `headers` 已正确配置（表头决定列数与类型）

### 12.3 编辑器里看不到预览
预览数据要用 **`preview_data`**，而不是 `set_data()`（`preview_data` 仅编辑器生效，两者互斥地分别在编辑/运行态生效）。

### 12.4 表头 id 重复
`TableRoot.set_headers` 会检测重复 id 并输出 `push_error`（"Duplicate header cell ID found"）。请保证每个表头资源的 `id` 唯一。

### 12.5 行数据列数与表头不一致
`_populate_rows` 按 `header_cells[cell_index]` 取类型，**行数据列数超出表头列数会越界报错**；少于表头列数则对应列留空。建议每行列数与表头严格一致。

### 12.6 百分比显示不对
`PERCENTAGE` 单元格的输入是 **0~1 的小数分数**（内部 ×100 后加 `%`）。`0.85` 会显示 `85%`，而不是 `0.85%`。

### 12.7 货币符号是英文 $
在 Inspector 的 `currency_cell_currency_symbol` 改成 `¥` 等符号即可。

### 12.8 滚轮不滚动
滚动条走的是自绘滚动逻辑（`scroll_bar_custom_step` 控制步长），请确认表格尺寸足够小（内容超出可视区），且 `scroll_bar_visible` 不是 `NeverShow`。

### 12.9 修改插件源码的坑
- 插件内部用 `uid://` 预加载场景，改动目录结构或删除 `.uid` 文件会导致加载失败
- 图标等资源硬编码 `res://addons/table_plus/` 路径，必须保持插件位于该路径

### 12.10 命名冲突提醒
本项目约定 `class_name` 避开 Godot 内置类名（详见项目记忆/命名规范）。使用 TablePlus 时，业务侧类名不要与 `TableRoot`、`TableCell`、`TableRow` 等插件全局类重名，以免解析冲突。

---

## 13. API 速查表

### 13.1 全局枚举（`TableGlobals`）

```gdscript
enum CellType    { TEXT = 0, NUMBER, CURRENCY, PERCENTAGE, DATE, BOOLEAN, PROGRESS }
enum SortState   { NONE = 0, ASC = 1, DESC = 2 }
enum OverflowMode { CLIP, ELLIPSIS }
```

### 13.2 单元格类型与专属枚举

| 类 | 专属枚举 |
|---|---|
| `NumberTableCell` | `DelimiterType { NONE, THOUSAND, TEN_THOUSAND }`、`RoundMode { ROUND, FLOOR, CEIL }` |
| `CurrencyTableCell` | `RoundMode { ROUND, FLOOR, CEIL }` |
| `PercentageTableCell` | `RoundMode { ROUND, FLOOR, CEIL }` |
| `DateTableCell` | `DateFormat`（9 种，见 5.4） |
| `TableRoot` | `ScrollbarVisibility { Auto, AlwaysShow, NeverShow }`、`InteractionMode { Row, Cell }` |

### 13.3 主节点常用方法

| 方法 | 说明 |
|---|---|
| `set_data(data: Array[Array])` | 设置运行时数据（运行态生效） |
| （属性）`data: Array[Array]` | 同 `set_data`，可读 |
| `set_resize(size: Vector2)` | 手动设置表格尺寸（一般由布局自动处理） |
| `export_data_changed(key, value)` | 配置变更信号 |

### 13.4 常用信号

| 信号 | 参数 |
|---|---|
| `row_clicked` | `(row_index: int, row: TableRow)` |
| `row_mouse_entered` / `row_mouse_exited` | `(row_index: int, row: TableRow)` |
| `cell_clicked` | `(row_index: int, column_index: int, cell: TableCell)` |
| `export_data_changed` | `(key: String, value: Variant)` |

### 13.5 TableCell 常用成员

- `content: Variant` —— 单元格原始数据
- `horizontal_alignment` / `vertical_alignment` / `width_ratio` / `overflow_mode`
- `get_content_control() -> Control` —— 返回显示控件（RichTextLabel / TextureRect / ProgressBar）
- `compare_values(a, b, sort_state) -> bool` —— 排序比较
- 点击触发 `clicked` 信号（Cell 交互模式下冒泡为 `cell_clicked`）

---

*本教程基于插件源码 v1.0 编写，插件文件位于 `.addons/table-plus-611c0c27e5b5079db1ae5b19db46b987ff8b6dbb/addons/table_plus/`。*
