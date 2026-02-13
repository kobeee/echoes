# Echoes iOS TabBar 专项最佳实践说明 v1.0

**日期**: 2026-02-13  
**范围**: iPhone 主壳导航与地图页底部内容布局

## 1. 采用方案（唯一）

1. 主壳使用系统 `TabView` 承载 5 个 Tab，不再使用自定义 TabBar 叠层。
2. 地图页将发现卡片与定位胶囊放在页面底部覆盖层，并显式预留 TabBar 安全空间，避免与系统浮动 TabBar 重叠。
3. TabBar 视觉通过 `.toolbarBackground(..., for: .tabBar)` 统一主题色，不破坏系统交互语义。

## 2. 选择依据（官方规范对齐）

- 系统导航优先：Apple 官方推荐使用系统 Tab 导航构建应用主信息架构。
- TabBar 外观定制应基于系统 API，而非自行绘制替代系统容器。
- 需要为底部系统栏预留安全区域，避免内容被 Home Indicator / TabBar 吞没。

## 3. 研发落地点

- 主壳文件：`src/ios/EchoesApp/App/Root/RootView.swift`
- 地图页文件：`src/ios/EchoesApp/Features/Map/MapHomeView.swift`
- 验证方式：`build_sim` + `test_sim` + `install_app_sim` + `launch_app_sim` + 截图核验

## 4. 参考资料（官方）

1. SwiftUI `TabViewCustomization`
   - https://developer.apple.com/documentation/SwiftUI/TabViewCustomization
2. SwiftUI `toolbarBackground(_:for:)`
   - https://developer.apple.com/documentation/swiftui/view/toolbarbackground(_:for:)-5ybst
3. SwiftUI `safeAreaInset(edge:alignment:spacing:content:)`
   - https://developer.apple.com/documentation/swiftui/view/safeareainset(edge:alignment:spacing:content:)-4s51l
4. Apple HIG - Navigation
   - https://developer.apple.com/design/human-interface-guidelines/navigation
5. Apple 文档：Enhancing your app’s content with tab navigation
   - https://developer.apple.com/documentation/SwiftUI/Enhancing-your-app-content-with-tab-navigation
