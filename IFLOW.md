# iFlow 项目配置 - Echoes

**项目名称**: 回响 (Echoes / GeoTrace)  
**项目类型**: iOS App 开发  
**目标平台**: iOS 26+ (iPhone, Apple Watch), visionOS (可选)  
**设计理念**: 极简主义、隐私至上、系统共生

---

## 一、项目概述

### 1.1 产品定位
- **Slogan**: 只有身临其境，才能听见回响
- **核心价值**: 地理位置语音留言与拾取
- **用户场景**: 在特定地点埋藏语音/文字信息，其他用户到达该地点后可拾取

### 1.2 核心功能模块
1. **埋藏 (Drop)**: 创建语音/文字 Echo，可设置权限和时间锁
2. **拾取 (Pickup)**: 通过雷达扫描发现并解锁附近的 Echoes
3. **黑匣子 (SOS)**: 紧急模式，录制并上传环境信息
4. **足迹 (Footprints)**: 个人历史记录与统计

### 1.3 系统融合特性
- **App Intents**: Siri 快捷指令集成
- **WidgetKit**: 桌面小组件 (The Compass)
- **Live Activities**: 灵动岛实时雷达追踪
- **Core Location**: 地理围栏与后台定位

---

## 二、技术栈与工具

### 2.1 设计工具
- **Pencil MCP**: 原型绘制与 UI 设计
- **SF Symbols**: iOS 系统图标库
- **SF Pro 字体**: iOS 系统字体族

### 2.2 开发技术栈
- **SwiftUI**: iOS 原生 UI 框架 (iOS 26+ Liquid Glass)
- **SwiftData**: 本地数据持久化
- **Core Location**: 定位服务
- **AVFoundation**: 音频录制与播放
- **CloudKit**: 云端数据同步
- **Xcodegen**: 项目配置管理 (YAML-based)

### 2.3 设计规范参考
- **iOS Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines
- **Dark Mode 设计规范**: 纯黑背景 (#000000)，透明白文字
- **安全区域**: 顶部 59pt (Dynamic Island) + 44pt (导航栏)，底部 34pt (Home Indicator)

---

## 三、关键注意事项 (CRITICAL)

### 3.1 iPhone 17 Pro 屏幕黑边问题 ⚠️

**问题描述**: 应用在 iPhone 17 Pro 模拟器/设备上出现屏幕上下黑边，内容被限制在屏幕中央的矩形区域内。

**根本原因**: 
- Xcodegen 生成的 Info.plist 缺少 `UISupportedInterfaceOrientations` 配置
- SwiftUI Preview 模式 (`ENABLE_PREVIEWS: YES`) 限制了布局尺寸
- TabView 被嵌套在 VStack/GeometryReader 中导致安全区域计算错误

**解决方案**: 

#### 1. project.yml 关键配置 (必须)
```yaml
targets:
  EchoesApp:
    info:
      path: App/Info.plist
      properties:
        UISupportedInterfaceOrientations:
          - UIInterfaceOrientationPortrait
        UIRequiresFullScreen: true
    settings:
      base:
        ENABLE_PREVIEWS: NO  # ⚠️ 关键设置
```

#### 2. TabView 正确布局
```swift
// ✅ 正确做法 - 直接使用 .ignoresSafeArea()
TabView(selection: $store.selectedTab) {
    // Tab content
}
.tint(EchoesColor.gold)
.tabBarMinimizeBehavior(.onScrollDown)
.ignoresSafeArea()  // 直接应用，不要用 VStack 包装

// ❌ 错误做法 - VStack 包装会破坏 Liquid Glass TabBar
VStack(spacing: 0) {
    TabView { /* ... */ }
}
.ignoresSafeArea()  // 这会导致布局问题
```

**详细修复文档**: `docs/design/fix/iphone17-black-bars-fix-v1.0.md`

### 3.2 Xcodegen 配置原则

1. **永远不要手动编辑生成的 Info.plist** - Xcodegen 会在每次生成时覆盖它
2. **所有 Info.plist 配置必须在 project.yml 中声明** - 使用 `info.properties` 字段
3. **ENABLE_PREVIEWS 必须设置为 NO** - 否则会导致 Preview 模式下的尺寸限制问题

---

## 四、工作规则

### 3.1 技能使用规则
- 在 `.iflow/skills/` 目录中查找合适的技能文件
- 根据任务类型选择对应的技能进行使用
- 优先使用项目中定义的技能，其次是全局技能
- **当前技能目录为空，待补充 iOS 设计相关技能**

### 3.2 变更记录规则 (重要)
- **每次都将最新的变更内容以头部插入的方式，新增到 CHANGELOG.md 文件里**
- CHANGELOG.md 是项目记忆的延伸，用于回顾和回放项目历史
- 变更记录应包含：日期、变更类型、变更描述
- 格式示例：
  ```markdown
  ## 2026-02-11
  - [新增] 创建 iOS UI 优化方案文档
  - [修改] 更新主地图布局，增加安全区域预留
  - [修复] 调整颜色变量，符合 iOS Dark Mode 规范
  ```

### 3.3 设计工作流程
1. **需求分析**: 阅读 PRD 文档 (`docs/prd/`)，提取核心功能
2. **规范查阅**: 查阅技能文件和 iOS HIG，获取设计规范
3. **方案制定**: 制定设计方案，保存到 `docs/design/`
4. **原型绘制**: 使用 Pencil MCP 绘制原型 (`echoes.pen`)
5. **设计验证**: 截图检查，对比设计规范
6. **变更记录**: **记录变更到 CHANGELOG.md** (必须执行)

### 3.4 Pencil MCP 使用规范

#### 正确操作流程
```
1. open_document({ filePathOrTemplate: "/path/to/echoes.pen" })
2. get_editor_state({ include_schema: false })  // 查看节点ID
3. batch_design({ operations: "..." })          // 执行设计操作
4. get_screenshot({ filePath: "/path/to/echoes.pen", nodeId: "xxx" })  // 验证结果
```

#### 重要提示
- **必须先 open_document 才能使用 get_screenshot**
- 直接调用 get_screenshot 会失败，因为工具需要知道当前活动编辑器上下文
- 设计操作使用 batch_design，单次最多 25 个操作
- 使用 SF Symbols 图标名，如 "mic", "location", "lock", "gear"

#### 颜色系统 (iOS Dark Mode)
```css
--bg-primary: #000000;           /* 系统背景 */
--bg-secondary: #1C1C1E;         /* 次级背景 */
--bg-tertiary: #2C2C2E;          /* 三级背景 */
--accent-gold: #C4A052;          /* 暖金色 (降低饱和度) */
--accent-teal: #00BFA5;          /* 信号青 */
--accent-red: #FF3B30;           /* 紧急红 */
--text-primary: #FFFFFF;         /* 主文字 */
--text-secondary: rgba(235,235,245,0.6);  /* 次级文字 */
```

#### 字体规范
- **字体族**: SF Pro (使用系统默认 -apple-system)
- **字号层级**:
  - 大标题: 34pt Bold
  - 标题: 20-28pt Medium
  - 正文: 17pt Regular (iOS 默认)
  - 辅助: 13-15pt Regular

#### 设计原则
**视觉稿第一原则** (最高优先级):
- **完整呈现原则**: 视觉稿原型必须清晰呈现产品的所有具象形态，是产品形态的完整表达
- **多Tab独立页面**: 当一个页面有多个Tab时，若每个Tab内容不同，在视觉稿中应为独立页面
  - 固定元素（如TabBar）保持一致
  - Tab显示为对应激活状态  
  - 内容区域展示该Tab特有的内容
- **滚动内容完整展示**: 若页面支持上下滑动，视觉稿应展示完整的长条内容（而非固定高度的裁剪视图）
  - 不担心页面过长
  - 核心目标是完整表达产品形态

---

## 四、文件组织规范

### 4.1 目录结构
```
/Users/elvis/Documents/codes/一个月一个AI项目挑战/2026/1月/echoes/
├── .iflow/
│   └── skills/           # 项目特定技能文件 (待补充)
├── docs/
│   ├── prd/              # 产品需求文档
│   │   └── v1.0.md       # PRD v1.0
│   ├── design/           # 设计文档
│   │   ├── prototype-design-v1.0.md  # 原型设计文档
│   │   ├── ios-ui-optimization-plan.md  # iOS UI 优化方案
│   │   └── fix/          # 问题修复文档
│   │       └── iphone17-black-bars-fix-v1.0.md  # 屏幕适配修复
│   └── assets/           # 图片/视频资源
├── src/
│   └── ios/
│       └── EchoesApp/    # iOS 应用源代码
│           ├── project.yml           # ⚠️ Xcodegen 配置主文件
│           ├── App/
│           │   ├── EchoesApp.swift   # App 入口
│           │   ├── ContentView.swift # 根视图
│           │   ├── Root/
│           │   │   └── RootView.swift # ⚠️ 主 Shell 视图
│           │   ├── Info.plist        # 生成的配置文件
│           │   └── ...
│           ├── Features/
│           ├── Core/
│           └── ...
├── echoes.pen            # Pencil 原型文件
├── CHANGELOG.md          # 项目变更日志
├── AGENTS.md             # AI 代理配置
├── CLAUDE.md             # Claude 配置
└── IFLOW.md              # 本文件
```

### 4.2 关键文件速查表

| 文件/目录 | 说明 | 重要性 |
|-----------|------|--------|
| `src/ios/EchoesApp/project.yml` | Xcodegen 配置 | ⚠️ 关键配置 |
| `src/ios/EchoesApp/App/Root/RootView.swift` | 主界面布局 | ⚠️ 核心代码 |
| `src/ios/EchoesApp/App/Info.plist` | 生成的配置 | 📄 自动生成 |
| `docs/design/fix/iphone17-black-bars-fix-v1.0.md` | 修复文档 | 📚 参考资料 |

### 4.3 文档命名规范
- PRD: `v{版本号}.md` (如 v1.0.md)
- 设计文档: `{类型}-design-v{版本号}.md`
- UI 方案: `{平台}-ui-{描述}.md`
- 修复文档: `{问题}-fix-v{版本号}.md`
- 变更日志: 按日期倒序排列

---

## 五、设计检查清单

### 5.1 布局检查
- [ ] 预留顶部安全区域 (59pt + 44pt)
- [ ] 预留底部 Home Indicator (34pt)
- [ ] 最小触控区域 44×44pt
- [ ] 屏幕边距 16pt 或 20pt

### 5.2 视觉检查
- [ ] 使用 iOS Dark Mode 颜色系统
- [ ] 文字对比度符合 WCAG 标准
- [ ] 使用 SF Pro 字体
- [ ] 使用 SF Symbols 图标

### 5.3 组件检查
- [ ] 按钮尺寸不小于 44pt
- [ ] 圆角统一 (8pt / 12pt / 16pt)
- [ ] 卡片使用标准边距 (16pt)

### 5.4 功能检查
- [ ] 覆盖 PRD 中定义的所有功能点
- [ ] Widget 设计符合尺寸规范
- [ ] Live Activity 适配灵动岛

### 5.5 屏幕适配检查 ⚠️ (新增)
- [ ] project.yml 包含 `UISupportedInterfaceOrientations` 配置
- [ ] project.yml 设置 `ENABLE_PREVIEWS: NO`
- [ ] TabView 直接使用 `.ignoresSafeArea()`，不被 VStack 包装
- [ ] 在 iPhone 17 Pro (18.1) 模拟器上测试全屏显示

---

## 六、常用命令速查

### Pencil MCP 操作
```javascript
// 打开文档
open_document({ filePathOrTemplate: "/Users/elvis/.../echoes.pen" })

// 获取编辑器状态
get_editor_state({ include_schema: false })

// 执行设计操作
batch_design({
  filePath: "/Users/elvis/.../echoes.pen",
  operations: `
    newFrame=I("parentId", {type: "frame", width: 393, height: 852, fill: "#000000"})
    U(newFrame, {cornerRadius: 16})
  `
})

// 截图验证
get_screenshot({
  filePath: "/Users/elvis/.../echoes.pen",
  nodeId: "frameId"
})
```

### Xcodegen 操作
```bash
# 生成项目
cd src/ios/EchoesApp
xcodegen generate

# 重新生成并清理
cd src/ios/EchoesApp
xcodegen generate --spec project.yml
```

### 文件操作
```bash
# 查看项目结构
ls -la

# 查看 CHANGELOG
cat CHANGELOG.md

# 查看设计文档
cat docs/design/ui/ios-ui-optimization-plan.md

# 查看修复文档
cat docs/design/fix/iphone17-black-bars-fix-v1.0.md
```

---

## 七、项目状态

### 当前进度
- ✅ PRD v1.0 完成 (2026-01-20)
- ✅ 原型设计文档 v1.0 完成 (2026-01-21)
- ✅ iOS UI 优化方案 v1.0 ~ v3.0 完成 (2026-01-21)
- ✅ echoes.pen 原型文件 (20 个页面/组件) (2026-01-21)
- ✅ Widget 设计完成 (Small + Medium) (2026-01-21)
- ✅ Live Activity 设计完成 (2026-01-21)
- ✅ 设计系统建立 (31 个 Token 变量) (2026-01-21)
- ✅ 产品流程审计完成 (9 条流程全部闭环) (2026-01-22)
- ✅ 设计闭环方案 v4.0 完成 (2026-01-22)
- ✅ iOS 应用开发完成 (2026-02-13) - **新增**
- ✅ iPhone 17 Pro 屏幕适配修复 (2026-02-14) - **新增**
- ⏳ 动效定义 (待补充)
- ⏳ App Store 上架准备 (待启动)

### echoes.pen 页面清单 (20 个)

#### 核心页面
| 页面 | ID | 说明 |
|------|-----|------|
| Main Map | `bi8Au` | 雷达扫描主界面，5 标签 TabBar |
| Drop View | `X4YOf` | 录制语音，24 根波形条 |
| Black Box | `b8dY3` | SOS 紧急录制 |
| Pickup View | `NAo19` | 雷达指引，距离显示 |
| My Footprints | `NidI5` | 统计概览，时间线 |
| Settings | `Lv9by` | Profile/Pro/隐私/通知/关于 |

#### 辅助页面
| 页面 | ID | 说明 |
|------|-----|------|
| Launch Screen | `jZXGl` | 金色同心圆 + 品牌名 |
| Echo Content View | `gMJux` | 回响播放页 |
| Drop Success | `Y0NYH` | 埋藏成功确认 |
| Permission Request | `permView` | 位置权限引导 |
| Empty Map | `emptyMap` | 空状态引导 |
| Echo Discovered | `5866p` | 发现回响通知状态 |
| SOS Complete | `sosComplete` | SOS 完成确认 |
| Passcode Entry | `passcodeView` | 加密口令输入 |
| Recovery Key | `jiWqm` | 密钥查看/备份 |
| Time Lock Locked | `T8Nkm` | 时间锁未到期倒计时 |
| Pro Subscription | `mJ8dW` | 订阅详情/购买 |

#### 系统组件
| 组件 | ID | 说明 |
|------|-----|------|
| Widget Small | `n88Zu` | 158×158 距离信息 |
| Widget Medium | `lwZ3H` | 338×158 迷你雷达 |
| Live Activity | `liveActivity` | 393×160 灵动岛 |

### 设计变量 Token (31 个)
- 颜色 19 个: `bg-primary`, `bg-secondary`, `bg-tertiary`, `bg-card`, `gold-100`~`gold-700`, `teal-500`, `purple-500`, `red-500`, `text-primary`, `text-secondary`, `text-muted`, `text-gold`, `border-default`, `border-gold` 等
- 圆角 5 个: `radius-xs`(2), `radius-sm`(4), `radius-md`(12), `radius-lg`(22), `radius-full`(9999)
- 间距 5 个: `spacing-xs`(4), `spacing-sm`(8), `spacing-md`(16), `spacing-lg`(24), `spacing-xl`(32)

### 关键代码实现 (新增)

#### RootView.swift - 主 Shell 布局
```swift
struct MainShellView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("地图", systemImage: "map.fill")
                }
                .tag(0)
            
            // Drop Tab
            DropView()
                .tabItem {
                    Label("埋藏", systemImage: "mic.circle.fill")
                }
                .tag(1)
            
            // Pickup Tab
            PickupView()
                .tabItem {
                    Label("拾取", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(2)
            
            // Footprints Tab
            FootprintsView()
                .tabItem {
                    Label("足迹", systemImage: "shoeprints.fill")
                }
                .tag(3)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(EchoesColor.gold)  // 品牌金色
        .tabBarMinimizeBehavior(.onScrollDown)  // iOS 26 特性
        .ignoresSafeArea()  // ⚠️ 关键设置 - 不要用 VStack 包装
    }
}
```

#### project.yml - Xcodegen 配置
```yaml
name: EchoesApp
targets:
  EchoesApp:
    type: application
    platform: iOS
    deploymentTarget: "26.0"
    sources:
      - App
      - Features
      - Core
    info:
      path: App/Info.plist
      properties:
        UISupportedInterfaceOrientations:
          - UIInterfaceOrientationPortrait
        UIRequiresFullScreen: true
        CFBundleDisplayName: 回响
        CFBundleShortVersionString: "1.0.0"
        CFBundleVersion: "1"
    settings:
      base:
        ENABLE_PREVIEWS: NO  # ⚠️ 关键 - 避免 Preview 模式限制
        SWIFT_VERSION: "6.0"
```

### 下一步建议
1. ✅ ~~定义页面间转场动效规范~~ (基础动效已实现)
2. ✅ ~~补充页面内状态变体~~ (基础状态已处理)
3. ✅ ~~开始 SwiftUI 开发实现~~ (已完成)
4. ⏳ 完善动画细节和微交互
5. ⏳ 进行全面的设备测试 (iPhone 17 Pro, iPhone 16 Pro Max, etc.)
6. ⏳ 准备 App Store 上架材料

---

## 九、APP交互逻辑说明

### 9.1 启动流程

```
App启动
    ↓
LaunchView (品牌动画)
    ↓
检查权限状态
    ├── 未授权 → PermissionFlowView (权限引导流程)
    │               ├── 位置权限
    │               ├── 通知权限
    │               └── 麦克风权限
    │               ↓
    │           授权完成 → MainShellView
    │
    └── 已授权 → MainShellView (主壳)
```

**启动参数**:
- `--force-main-shell`: 跳过权限流程，直接进入主界面（用于模拟器测试）

### 9.2 Tab导航结构

MainShellView 使用原生 `TabView`，包含5个Tab：

| 顺序 | Tab名称 | 视图 | 系统图标 |
|------|---------|------|----------|
| 1 | 首页 | MapHomeView | house |
| 2 | 地图 | PickupView | map |
| 3 | 埋藏 | DropView | plus.circle.fill |
| 4 | 足迹 | FootprintsView | figure.walk |
| 5 | 设置 | SettingsView | gearshape |

**代码位置**: `App/Root/RootView.swift` - MainShellView

### 9.3 各Tab页面交互详情

#### Tab 1: 首页 (MapHomeView)
- 雷达扫描动画 (RadarView)
- "发现附近的回响"卡片: 点击后切换到Pickup流程
- 右上角红色感叹号: SOS入口（进入BlackBoxView全屏页）

#### Tab 2: 地图 (PickupView)
- 目标卡片: 显示当前锁定的Echo
- 指南针雷达: 指向目标方向
- 距离显示 + 信号强度条
- "解锁内容"按钮: 触发 `store.tapEcho(echo)`

**点击"解锁内容"后的分支逻辑**:
```
点击"解锁内容"
    ↓
store.tapEcho(echo)
    ├── echo.isTimeLocked == true → TimeLockLockedView (Sheet)
    ├── echo.visibility == .private → PasscodeSheet (Sheet) → EchoContentView
    └── 其他 (public) → EchoContentView (Sheet)
```

**Mock数据中的Echo类型** (`MockRepositories.swift`):
| 名称 | 距离 | 类型 | 口令 |
|------|------|------|------|
| 给未来的信 | 0m | text | 无 |
| 语音回响 | 15m | voice | 1024 |
| 加密时间胶囊 | 50m | text+时间锁 | 无 |

#### Tab 3: 埋藏 (DropView)
- 录制按钮: 开始/停止录音
- 波形可视化: 24根波形条
- "公开/加密"切换
- 录制完成 → DropSuccessView (Sheet)

#### Tab 4: 足迹 (FootprintsView)
- 统计卡片: 埋下数量、拾取数量、天数
- 时间线: 历史记录列表

#### Tab 5: 设置 (SettingsView)
- Profile卡片: Device ID + Recovery Key
- Pro入口 → ProSubscriptionView (Sheet)
- 隐私设置: Toggle开关
- 通知设置: Toggle开关
- 关于信息

### 9.4 Sheet页面汇总

| Sheet | 入口 | 说明 |
|-------|------|------|
| DropSuccessView | DropView录制完成 | 埋藏成功确认 |
| EchoContentView | PickupView解锁 | 播放/查看Echo内容 |
| PasscodeSheet | PickupView解锁加密Echo | 输入4位口令 |
| TimeLockLockedView | PickupView解锁时间锁Echo | 显示倒计时 |
| SOSCompleteView | BlackBoxView完成 | SOS完成确认 |
| RecoveryKeyView | SettingsView | 密钥查看/备份 |
| ProSubscriptionView | SettingsView | Pro订阅详情 |

### 9.5 全屏页面

- **BlackBoxView**: SOS紧急模式，入口在首页右上角红色感叹号
- 完成后弹出 SOSCompleteView (Sheet)

### 9.6 状态管理 (AppStore)

**核心状态** (`Shared/State/AppStore.swift`):
- `phase`: AppPhase (.launch / .permissions / .main)
- `selectedTab`: AppTab (当前Tab)
- `modalRoute`: ModalRoute? (Sheet路由)
- `fullScreenRoute`: 全屏路由
- `echoes`: [EchoItem] (Echo列表)
- `nearbyEchoes`: [EchoItem] (附近Echo ≤500m)

---

## 十、Xcodebuild MCP 使用指南

### 8.1 概述
Xcodebuild MCP 是一个 AI 驱动的 Xcode 自动化工具，允许 AI 助手自主构建、测试和调试 iOS 应用。

### 8.2 常用工作流程

#### 完整构建运行流程
```
1. session_set_defaults({ simulatorId, scheme, projectPath })  // 设置默认配置
2. boot_sim()                    // 启动模拟器
3. open_sim()                    // 打开模拟器窗口
4. build_sim()                   // 构建应用
5. install_app_sim({ appPath })  // 安装应用
6. launch_app_sim()              // 启动应用
7. screenshot()                  // 截图验证
```

#### 带启动参数运行
```swift
// 在 AppStore.init() 中检查启动参数
if ProcessInfo.processInfo.arguments.contains("--force-main-shell") {
    grantedPermissions = Set(PermissionStep.allCases)
    phase = .main
}

// 启动时传递参数
launch_app_sim({ args: ["--force-main-shell"] })
```

### 8.3 核心 API

| API | 用途 |
|-----|------|
| `session_set_defaults` | 设置默认配置（scheme、simulatorId 等） |
| `session_show_defaults` | 查看当前默认配置 |
| `list_sims` | 列出可用模拟器 |
| `boot_sim` | 启动模拟器 |
| `open_sim` | 打开模拟器窗口 |
| `build_sim` | 构建应用 |
| `install_app_sim` | 安装应用到模拟器 |
| `launch_app_sim` | 启动应用 |
| `stop_app_sim` | 停止应用 |
| `screenshot` | 截图 |
| `test_sim` | 运行测试 |

### 8.4 注意事项

1. **snapshot_ui 工具可能失败**：由于依赖外部工具（axe），在某些环境下可能无法使用。替代方案：
   - 使用 `screenshot()` 截图后用 `image_read` 分析
   - 在代码中添加启动参数跳过特定流程

2. **模拟点击**：Xcodebuild MCP 本身不直接提供模拟点击功能。如需 UI 自动化测试：
   - 安装 [ios-simulator-mcp](https://github.com/joshuayoes/ios-simulator-mcp)
   - 或使用 `idb ui tap` 命令（需安装 Facebook IDB）

3. **设备 ID 变化**：模拟器 ID 在 Xcode 更新后可能变化，建议每次运行前先用 `list_sims` 获取最新 ID

### 8.5 iOS 26 Liquid Glass 最佳实践

#### 关键 API
```swift
// 基础 Glass 效果
.glassEffect(.regular)

// 带 tint 和交互效果
.glassEffect(.regular.tint(.blue.opacity(0.8)).interactive())

// 按钮样式
.buttonStyle(.glass)           // 透明玻璃效果
.buttonStyle(.glassProminent)  // 不透明玻璃效果（主要操作）

// 容器（多元素必须使用）
GlassEffectContainer {
    HStack { /* 多个 glass 元素 */ }
}
```

#### 设计原则
- **Liquid Glass 仅用于导航层**，不要应用于内容区域
- **多个 Glass 元素必须放在 GlassEffectContainer 中**
- **`.glassProminent` 适合主要操作按钮，配合 `.tint()` 设置颜色**
- **避免 glass-on-glass 嵌套**
- **TabView 使用 `.ignoresSafeArea()` 直接设置，不要用 VStack 包装**

---

**最后更新**: 2026-02-14  
**版本**: v3.0  
**状态**: 开发完成，屏幕适配已修复