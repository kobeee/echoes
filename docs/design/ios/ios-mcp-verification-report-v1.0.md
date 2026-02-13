# Echoes iOS MCP 验证报告 v1.0

**日期**: 2026-02-13  
**工具**: XcodeBuildMCP + Simulator

## 1. 构建验证

- `build_sim`（Scheme: EchoesApp）: ✅ 通过
- Widget Extension 编译: ✅ 通过
- Live Activity 编译: ✅ 通过

## 2. 测试验证

- `test_sim`（Scheme: EchoesApp）: ✅ 通过
- 测试结果: `6 passed / 0 failed`
- 覆盖点:
  - Time Lock 初始锁定态
  - Passcode 成功/失败校验
  - Witness -> Footprint 流程
  - SOS 生命周期
  - Deep Link 进入主流程
  - 私有回响触发口令页

## 3. 运行验证

- 模拟器安装: ✅ 成功（Bundle ID: `com.echoes.app`）
- 模拟器启动: ✅ 成功
- 截图核验: ✅ 主壳首页 `MapHomeView` 已稳定显示底部 5 Tab

## 4. 关键修复

1. Widget 安装失败修复：补齐 Widget `Info.plist` 的 `NSExtension/NSExtensionPointIdentifier=com.apple.widgetkit-extension`，通过 appex 占位符校验。
2. Deep Link 生效修复：App `Info.plist` 增加 `echoes://` URL Scheme。
3. Live Activity 生效修复：App `Info.plist` 增加 `NSSupportsLiveActivities`。
4. 路由修复：Deep Link 强制进入 `.main` phase，避免首启权限页阻断跳转。

## 5. 已知工具链说明

当前 Xcode/Runtime 组合会提示 deployment 被 `19.0 -> 26.0` 覆写警告；
该告警不影响当前构建、安装、运行、测试结果。

## 6. TabBar 可见性专项修复

- 症状：主地图页在部分运行路径下出现底部 TabBar 不可见/被底部安全区吞没。
- 修复：主壳统一改为系统 `TabView`（不再使用自定义 Tab 叠层）；地图页底部内容改为上浮布局并为系统浮动 TabBar 预留空间。
- 结果：通过模拟器重新 build/install/launch 验证，底部 Tab 持续可见，且不影响现有功能测试（6/6 通过）。
