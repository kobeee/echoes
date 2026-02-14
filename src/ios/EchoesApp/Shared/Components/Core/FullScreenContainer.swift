import SwiftUI

/// 全屏容器 - 确保内容填满整个屏幕（包括安全区域外）
/// 
/// 用于解决 iOS 26 Liquid Glass TabView 下 GeometryReader + ScrollView 结构的页面
/// 背景未延伸到安全区域外的问题。
///
/// ## 使用示例
///
/// ```swift
/// struct SettingsView: View {
///     var body: some View {
///         FullScreenContainer {
///             GeometryReader { geometry in
///                 ScrollView {
///                     // 内容...
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// 或使用 View Extension:
///
/// ```swift
/// struct FootprintsView: View {
///     var body: some View {
///         GeometryReader { geometry in
///             ScrollView {
///                 // 内容...
///             }
///         }
///         .fullScreenBackground()
///     }
/// }
/// ```
struct FullScreenContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // 背景层 - 延伸到安全区域外
            EchoesColor.bgPrimary
                .ignoresSafeArea()
            
            // 内容层
            content
        }
    }
}

// MARK: - View Extension

extension View {
    /// 将视图包装为全屏背景容器
    /// 
    /// 用于解决 iOS 26 Liquid Glass TabView 下背景未填满全屏的问题。
    /// 在 GeometryReader 外部调用此方法即可。
    ///
    /// ## 示例
    /// ```swift
    /// GeometryReader { geometry in
    ///     ScrollView { ... }
    /// }
    /// .fullScreenBackground()
    /// ```
    func fullScreenBackground() -> some View {
        FullScreenContainer { self }
    }
}
