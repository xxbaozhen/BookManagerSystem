# BookManagerSystem

> 基于 **Godot 4.7 .NET** 的 Windows 桌面端图书管理系统。
>
> 状态：**UI 页面制作中** —— 主窗口框架与 Dashboard 首页已完成，业务逻辑与数据库尚未开始，页面数据为模拟数据。

---

## 简介

BookManagerSystem 用于管理图书、用户与图书借阅数据，提供简洁现代的桌面管理界面。
项目采用 Godot Control 系统构建 UI，计划以 C# 实现业务与数据层、GDScript 实现界面交互，
并通过分层架构（UI → Service → Repository → SQLite）保持界面与业务解耦。

---

## 当前进度

已完成：

- 无边框圆角主窗口与 Windows 窗口控制（最小化 / 关闭）
- Sidebar 侧边栏（菜单状态切换）与 TopBar（搜索框、用户信息 Popup）
- `PageManager` 多页面动态切换机制
- **Dashboard 首页**：统计卡片、借阅 / 分类图表面板（占位）、最近借阅表、最近上新表
- 可复用组件：FontIcon、SidebarMenuButton、PanelHeader、StatisticsCard、LegendItem
- 集成 [TablePlus](addons/table_plus/) 表格插件，并提供配套浅色主题

待完成：其余业务页面、真实图表、数据层与业务逻辑（见[路线图](#开发路线)）。

---

## 计划功能

- 用户管理与登录权限
- 图书管理（增删改查、搜索、库存、ISBN、出版信息）
- 图书分类管理
- 图书借阅 / 归还、借阅历史、逾期状态
- Dashboard 数据概览与统计图表
- 系统设置、数据备份与恢复

---

## 技术栈

| 项 | 说明 |
| --- | --- |
| 引擎 | Godot **4.7** stable（.NET / mono 版） |
| 语言 | C#（业务 / 数据层）、GDScript（UI 与交互） |
| 平台 | Windows（Forward Plus 渲染，1600×900 无边框透明窗口） |
| 数据库 | SQLite（计划中，尚未接入） |
| 字体 / 图标 | 微软雅黑、FluentSystemIcons |
| 表格 | [TablePlus](addons/table_plus/) 插件 |

---

## 快速开始

### 环境要求

- [Godot 4.7 .NET 版](https://godotengine.org/download)（mono 构建）
- [.NET SDK 8.0](https://dotnet.microsoft.com/download)（桌面平台目标框架 `net8.0`）

### 运行

用 Godot .NET 版打开项目根目录的 `project.godot`，按 **F5** 运行；
或使用命令行：

```bash
# 在 Godot 编辑器中打开
godot --path .

# 直接运行主场景
godot --path . res://src/ui/views/main_window/main_window.tscn
```

### 构建 C#

```bash
dotnet build BookManagerSystem.csproj
```

### 无头模式自检（可选）

```bash
godot --headless --path . --quit-after 120
```

---

## 项目结构

```text
res://
├── addons/table_plus/              # TablePlus 表格插件
├── assets/
│   ├── fonts/                      # 微软雅黑、FluentSystemIcons
│   ├── icons/  shaders/
│   └── themes/                     # *.tres 主题资源
├── src/
│   ├── docs/                       # 项目文档（PROJECT.md、TABLEPLUS.md）
│   ├── global/                     # 全局状态
│   └── ui/
│       ├── components/             # 可复用组件（场景 + 脚本）
│       │   ├── font_icon/
│       │   ├── menu_button/
│       │   ├── panel_header/
│       │   ├── statistics_card/
│       │   └── legend_item/
│       └── views/
│           ├── main_window/        # 主窗口（C# + 场景，含 internal/ 侧栏·顶栏·弹窗）
│           ├── pages/              # 由 PageManager 动态加载的页面
│           │   ├── page_manager.gd
│           │   └── dashboard/      # 首页
│           └── debug_page_test/    # 调试 / 截图验证页面
└── project.godot
```

页面统一放在 `src/ui/views/pages/<name>/<name>.tscn`，由 `PageManager` 按名称动态实例化
（在主窗口中设置 `load_page = "dashboard"`）。

---

## 文档

- [src/docs/PROJECT.md](src/docs/PROJECT.md) —— 项目目标、架构规划、分层设计与开发阶段路线图
- [src/docs/TABLEPLUS.md](src/docs/TABLEPLUS.md) —— TablePlus 插件使用说明

---

## 开发约定

- 目录 / 文件 / GDScript 使用 `snake_case`，节点与 `class_name` 使用 `PascalCase`
  （`class_name` 避开 Godot 内置类名）。
- UI 与业务逻辑分离：页面只负责展示与交互，复杂逻辑下沉到 Service / Repository。
- 可复用 UI 拆分为独立组件场景（`.tscn` + `.gd`），通过 `@tool` + `@export` 属性配置。
- 小步开发，保持 Git 提交清晰；重要设计变更同步更新 `src/docs/` 下文档。

> TablePlus 注意：其 `preview_data` 仅在编辑器中可见，运行时需调用 `set_data()` 注入数据；
> 表格主题见 `assets/themes/table_plus_light.tres`。

---

## 开发路线

| 阶段 | 内容 | 状态 |
| --- | --- | --- |
| Phase 1 | UI 框架（窗口 / 侧栏 / 顶栏 / PageManager） | ✅ 基本完成 |
| Phase 1.5 | UI 页面制作（Dashboard 已完成，其余页面进行中） | 🔧 进行中 |
| Phase 2–6 | 项目架构、数据库、用户 / 图书 / 借阅业务 | ⬜ 未开始 |
| Phase 7 | Dashboard 数据统计与真实图表 | ⬜ 未开始（UI 外壳已就绪） |
| Phase 8 | 系统设置、备份、优化与发布 | ⬜ 未开始 |

完整规划见 [src/docs/PROJECT.md](src/docs/PROJECT.md)。

---

## 许可证

本项目暂未声明开源许可证。
项目内使用的 [FluentSystemIcons](assets/fonts/LICENSE_FluentSystemIcons.txt) 字体遵循其各自许可。
