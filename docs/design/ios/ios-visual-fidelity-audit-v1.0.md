# Echoes iOS 视觉还原审计 v1.0

**日期**: 2026-02-13  
**基准**: `echoes.pen`（20 个页面/组件）  
**审计方式**: 页面语义、层级、布局结构、控件样式逐页对照

## 1. 还原结论

本轮采用单一实现方案：**以 `echoes.pen` 为唯一视觉源，逐页对齐 iPhone SwiftUI 页面结构，并保留后续 watchOS/visionOS 扩展边界**。

还原结果：
- 核心页面（Map/Drop/Pickup/SOS/Footprints/Settings）: 结构、配色、层级对齐
- 状态页面（Passcode/TimeLock/RecoveryKey/DropSuccess/SOSComplete/EchoContent）: 关键视觉与交互闭环对齐
- 系统能力（Widget Small/Medium、Live Activity、App Intents）: 入口与形态对齐

## 2. 逐页对照清单

| 视觉稿页面 | .pen ID | iOS 实现 | 对齐状态 |
|---|---|---|---|
| Launch Screen | `jZXGl` | `LaunchView` | 已对齐 |
| Permission Request | `permView` | `PermissionFlowView` | 已对齐 |
| Main Map | `bi8Au` | `MapHomeView` | 已对齐 |
| Empty Map | `emptyMap` | `MapHomeView` 空态分支 | 已对齐 |
| Echo Discovered | `5866p` | `MapHomeView` 发现卡片分支 | 已对齐 |
| Drop View | `X4YOf` | `DropView` | 已对齐 |
| Drop Success | `Y0NYH` | `DropSuccessView` | 已对齐 |
| Pickup View | `NAo19` | `PickupView` | 已对齐 |
| Passcode Entry | `passcodeView` | `PasscodeSheet` | 已对齐 |
| Time Lock Locked | `T8Nkm` | `TimeLockLockedView` | 已对齐 |
| Echo Content View | `gMJux` | `EchoContentView` | 已对齐 |
| Black Box | `b8dY3` | `BlackBoxView` | 已对齐 |
| SOS Complete | `sosComplete` | `SOSCompleteView` | 已对齐 |
| Recovery Key | `jiWqm` | `RecoveryKeyView` | 已对齐 |
| My Footprints | `NidI5` | `FootprintsView` | 已对齐 |
| Settings | `Lv9by` | `SettingsView` | 已对齐 |
| Pro Subscription | `mJ8dW` | `ProSubscriptionView` | 已对齐 |
| Widget Small | `n88Zu` | `CompassSmallWidget` | 已对齐 |
| Widget Medium | `lwZ3H` | `CompassMediumWidget` | 已对齐 |
| Live Activity | `liveActivity` | `PickupLiveActivityWidget` | 已对齐 |

## 3. 本轮关键微调点

1. 地图首页改为雷达中心布局（扫描状态 + SOS 按钮 + 发现卡片）。
2. Pickup 改为视觉稿单目标追踪样式（目标卡片、距离主数字、信号条、解锁按钮）。
3. Passcode 改为 4 位点阵 + 数字键盘交互，不再使用系统输入框。
4. TimeLock / Recovery / Pro / SOS Complete 全部按视觉稿重排（层级、色彩、按钮语义）。
5. Widget Small/Medium 与 Live Activity 文案结构对齐视觉稿。
6. Main Shell 增加 TabBar 安全区动态上浮，保证底部 5 Tab 在 iPhone 全机型可见。

## 4. 扩展预留（本期仅 iPhone）

- 视觉与业务共用模型继续集中在 `Shared/`，为 watchOS/visionOS 复用留边界。
- 平台差异能力维持在 `Platform`/target 维度隔离，不影响本期 iPhone 交付。
