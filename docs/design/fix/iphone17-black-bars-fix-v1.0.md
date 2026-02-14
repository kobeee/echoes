# iPhone 17 Pro 屏幕黑边问题 - 关键修复文档

> **文档编号**: FIX-IPHONE17-BLACK-BARS-001  
> **日期**: 2026-02-14  
> **严重等级**: P0 - 严重（影响所有页面显示）  
> **状态**: ✅ 已修复并验证

---

## 1. 问题概述

### 1.1 现象描述
应用在 iPhone 17 Pro 模拟器/真机上运行时，屏幕上下出现巨大黑边：

```
┌─────────────────────────────┐
│      状态栏 (正常)            │
├─────────────────────────────┤
│      黑色区域 (异常)          │ ← 顶部黑边
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    应用内容区域        │  │ ← 被压缩在中间
│  │    (仅占屏幕60%)       │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│      黑色区域 (异常)          │ ← 底部黑边
├─────────────────────────────┤
│      TabBar (位置正确)        │
└─────────────────────────────┘
```

### 1.2 影响范围
- **所有页面**：主页面、设置页面、SOS 页面等均受影响
- **设备限制**：iPhone 17 Pro（可能与屏幕尺寸/比例有关）
- **iOS 版本**：iOS 26.2

---

## 2. 根本原因

### 2.1 直接原因
**Xcodegen 项目配置不完整** - `project.yml` 未正确声明 Info.plist 键值：

```yaml
# 修复前 ❌ - 缺少 properties 配置
targets:
  EchoesApp:
    info:
      path: App/Info.plist  # 仅指定路径，未声明内容
```

**问题**：
- Xcodegen 生成的 `Info.plist` 缺少 `UISupportedInterfaceOrientations`
- 缺少 `UIRequiresFullScreen` 声明
- iOS 无法正确识别应用的屏幕适配策略

### 2.2 间接原因
**SwiftUI 布局冲突**：
- 使用 `VStack` 包裹 `TabView` 并添加 `.ignoresSafeArea()`
- 干扰了 iOS 26 Liquid Glass TabView 的自动全屏布局
- `ENABLE_PREVIEWS: YES` 可能导致 Preview 模式限制尺寸

### 2.3 技术原理
**iOS 26 Liquid Glass TabView 特性**：
1. 使用原生 `TabView` 自动获得悬浮椭圆形 TabBar
2. 有自己的安全区域计算和全屏适配机制
3. **不应**包裹在 `VStack/ZStack` 中或手动添加 `.frame()`

---

## 3. 修复方案

### 3.1 修复 1: project.yml 配置

**文件**: `src/ios/EchoesApp/project.yml`

```yaml
targets:
  EchoesApp:
    type: application
    platform: iOS
    # ... 其他配置
    info:
      path: App/Info.plist
      properties:  # ✅ 新增：声明 Info.plist 键值
        UISupportedInterfaceOrientations:
          - UIInterfaceOrientationPortrait
        UIRequiresFullScreen: true
        UILaunchScreen:
          UIColorName: LaunchScreenBackground
    settings:
      base:
        # ... 其他设置
        ENABLE_PREVIEWS: NO  # ✅ 修改：关闭 Preview 模式
```

**关键配置说明**：
| 配置项 | 作用 | 必需 |
|--------|------|------|
| `UISupportedInterfaceOrientations` | 声明支持的屏幕方向 | ✅ 是 |
| `UIRequiresFullScreen` | 声明应用需要全屏显示 | ✅ 是 (iOS 26 已弃用但仍需) |
| `UILaunchScreen` | 启动屏幕配置 | ✅ 是 |
| `ENABLE_PREVIEWS: NO` | 关闭 SwiftUI Preview | ✅ 是 |

### 3.2 修复 2: RootView.swift 布局

**文件**: `src/ios/EchoesApp/App/Root/RootView.swift`

```swift
// 修复前 ❌
private struct MainShellView: View {
    var body: some View {
        VStack(spacing: 0) {  // VStack 干扰布局
            TabView { ... }
        }
        .ignoresSafeArea()
        .background(EchoesColor.bgPrimary)
    }
}

// 修复后 ✅
private struct MainShellView: View {
    var body: some View {
        // 直接使用 TabView，不包裹在容器中
        TabView(selection: $store.selectedTab) {
            Tab(AppTab.map.title, systemImage: "house", value: AppTab.map) {
                MapHomeView()
            }
            // ... 其他 Tab
        }
        .tint(EchoesColor.gold)
        .tabBarMinimizeBehavior(.onScrollDown)
        .ignoresSafeArea()  // 直接应用到 TabView
    }
}
```

### 3.3 修复 3: 移除干扰元素

**移除浮动 "+" 按钮**（临时方案）：
- 该按钮使用固定 `padding(.bottom, 100)` 定位
- 会干扰 iOS 26 TabBar 的自动布局
- **建议**：重新设计为系统 Tab 或使用 `.toolbar()`

---

## 4. 验证步骤

### 4.1 构建验证
```bash
cd src/ios/EchoesApp

# 1. 重新生成工程
xcodegen generate

# 2. 构建（使用 Xcodebuild MCP）
xcodebuild_build_sim
```

### 4.2 运行时验证
```bash
# 3. 安装到 iPhone 17 Pro 模拟器
install_app_sim

# 4. 启动应用（跳过权限直接进入主页面）
launch_app_sim --args=["--force-main-shell"]

# 5. 截图验证
screenshot
```

### 4.3 验证标准
- [x] 主页面填满全屏，无上下黑边
- [x] 设置页面填满全屏
- [x] TabBar 正确显示在屏幕底部
- [x] Liquid Glass 悬浮效果正常
- [x] 状态栏和 Home Indicator 区域正常

---

## 5. 经验教训

### 5.1 Xcodegen 使用注意事项
1. **必须**在 `project.yml` 中声明所有 `Info.plist` 键值
2. 不要依赖手动修改生成的 `Info.plist`（会被覆盖）
3. 使用 `info.properties` 或 `info.excludes` 精确控制内容

### 5.2 iOS 26 Liquid Glass 最佳实践
1. **直接使用** `TabView`，不要包裹在容器中
2. **不要**手动添加 `.frame(maxWidth:maxHeight:)`
3. **不要**使用 `.background()` 修饰 TabView
4. 使用 `.ignoresSafeArea()` 直接应用到 TabView

### 5.3 调试技巧
1. 使用 `--force-main-shell` 启动参数快速进入主页面
2. 使用 Xcodebuild MCP 截图验证（`screenshot`）
3. 检查生成的 `Info.plist`：`plutil -p Echoes.app/Info.plist`

---

## 6. 相关文件

### 修改的文件
| 文件 | 修改类型 | 说明 |
|------|----------|------|
| `project.yml` | 修改 | 添加 Info.plist properties |
| `App/Root/RootView.swift` | 修改 | 简化 MainShellView 布局 |
| `App/Info.plist` | 生成 | 通过 Xcodegen 重新生成 |

### 参考文档
- `CHANGELOG.md` - 变更日志
- `docs/design/fix/ios-26-liquid-glass-layout-fix-v1.0.md` - 之前的修复方案

---

## 7. 后续建议

### 7.1 浮动 "+" 按钮替代方案
```swift
// 方案 1: 使用系统 Toolbar
TabView { ... }
    .toolbar {
        ToolbarItem(placement: .bottomBar) {
            Button { ... } label: { Image(systemName: "plus") }
        }
    }

// 方案 2: 放在某个 Tab 内部
Tab("埋藏", systemImage: "plus.circle.fill", value: .drop) {
    DropView()
}
```

### 7.2 其他设备验证
- [ ] iPhone 16 Pro
- [ ] iPhone 15 Pro
- [ ] iPhone SE (小屏)
- [ ] iPad (如支持)

---

**记录人**: Sisyphus AI Agent  
**最后更新**: 2026-02-14  
**版本**: v1.0
