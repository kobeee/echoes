# Echoes iOS 研发总方案 v1.0

**日期**: 2026-02-13  
**范围**: iPhone iOS App（含 Widget / Live Activity / App Intents）  
**后端策略**: 本期仅 Mock，本地闭环，后端接口下期接入  
**目标**: 100% 对齐 `echoes.pen` 页面语义与核心视觉层级，并完成产品功能闭环

---

## 1. 研发目标与唯一实现路径

### 1.1 本期必须达成
1. 完整实现 PRD 四大模块：Drop / Pickup / SOS / Footprints。
2. 实现系统能力：WidgetKit、Live Activities、App Intents、Core Location 权限流。
3. 页面与状态闭环：覆盖 `echoes.pen` 20 个设计页面和关键状态。
4. 项目结构可扩展：为 watchOS / visionOS 和后端接入预留清晰边界。

### 1.2 唯一最优方案（无备选）
采用 **Feature-First + Shared Core + Extension Targets** 架构：
- App 主目标负责核心业务流与页面状态。
- Shared Core 统一设计 Token、领域模型、Mock 仓储、深链路路由。
- Widget Extension 同时承载 Widget 与 Live Activity。
- App Intents 独立分层并与路由联动。

该方案同时满足：
- 视觉还原精度
- 端到端闭环
- 低耦合可扩展
- 后续接后端时最小改动

---

## 2. 目录与工程规划

## 2.1 仓库目录（固定）

```text
src/
  ios/
    EchoesApp/
      EchoesApp.xcodeproj
      App/
      Features/
      Shared/
      Extensions/
      Widgets/
      Intents/
      Resources/
      Tests/
  backend/   # 预留，当前不实现
```

### 2.2 Target 规划
1. `EchoesApp`（iOS 主 App）
2. `EchoesWidgets`（Widget + Live Activity）
3. `EchoesAppTests`（单测）

> 扩展预留：
> - `EchoesWatchApp`（预留目录和协议，不创建目标）
> - `EchoesVisionApp`（预留目录和协议，不创建目标）

---

## 3. 产品功能映射（设计稿 -> 研发实现）

| 视觉页 | 研发实现 | 关键状态 |
|---|---|---|
| Launch Screen | `LaunchView` | 启动动画 / 进入权限流 |
| Permission Request | `PermissionFlowView` | 位置/麦克风/通知分步授权 |
| Main Map | `MapHomeView` | 雷达、信号点、TabBar |
| Empty Map | `MapEmptyStateView` | 首次无内容引导 |
| Echo Discovered | `MapDiscoveryBannerView` | 发现回响 banner |
| Drop View | `DropView` | 语音/文字切换、时间锁、公开/加密 |
| Drop Success | `DropSuccessView` | 成功反馈 + 跳回地图 |
| Pickup View | `PickupView` | 距离、方向、信号强度 |
| Passcode Entry | `PasscodeSheet` | 加密解锁 |
| Time Lock Locked | `TimeLockLockedView` | 到期倒计时 |
| Echo Content View | `EchoContentView` | 播放、已阅标记 |
| Black Box | `BlackBoxView` | SOS 录制上传、进度态 |
| SOS Complete | `SOSCompleteView` | 完成反馈 + Recovery 提醒 |
| Recovery Key | `RecoveryKeyView` | 查看/复制/确认备份 |
| My Footprints | `FootprintsView` | 统计 + 时间线 |
| Settings | `SettingsView` | Profile/隐私/通知/关于 |
| Pro Subscription | `ProSubscriptionView` | Pro 功能与购买 |
| Widget Small | `CompassSmallWidget` | 快捷埋藏入口 |
| Widget Medium | `CompassMediumWidget` | 雷达摘要 |
| Live Activity | `PickupLiveActivityWidget` | 追踪态距离更新 |

---

## 4. 视觉与设计系统实现规范

### 4.1 Design Tokens（代码常量）
- 背景：`bgPrimary #000000`、`bgSecondary #1C1C1E`、`bgTertiary #2C2C2E`
- 品牌：`gold500 #D4AA40`、`teal500 #00BFA5`、`red500 #FF453A`
- 文本：`textPrimary #FFFFFF`、`textSecondary #98989F`
- 圆角：2/4/12/22/full
- 间距：4/8/16/24/32

### 4.2 组件级约束
1. 最小触控区域 `>= 44x44`。
2. 顶部安全区 `59pt`、底部 `34pt`（动态适配 safe area）。
3. TabBar 5 项统一结构，中心 CTA 独立层级。
4. SOS 按钮与核心 CTA 使用触觉反馈。

### 4.3 动效与无障碍
- 支持 Reduce Motion 降级。
- 支持 Dynamic Type。
- VoiceOver Label/Hint 覆盖核心交互点。

---

## 5. 业务架构与状态管理

## 5.1 分层
1. **Domain**：实体模型、用例协议。
2. **Data**：Mock Repository（本地内存 + 本地文件模拟）。
3. **Presentation**：SwiftUI View + ViewModel。
4. **Platform**：Location、Audio、Notifications、ActivityKit 封装。

### 5.2 状态容器
- `AppStore`（全局）：路由、权限状态、tab 状态、当前追踪。
- `FeatureStore`（局部）：Drop/Pickup/SOS/Settings 局部状态。
- 单向数据流：`Intent(Action) -> Reducer/UseCase -> State -> UI`。

### 5.3 Mock 策略（后端占位）
- `EchoRepositoryProtocol` + `MockEchoRepository`
- `SOSRepositoryProtocol` + `MockSOSRepository`
- `SubscriptionRepositoryProtocol` + `MockSubscriptionRepository`
- Mock 数据可在 App 内实时变更（便于演示完整闭环）

---

## 6. 系统能力接入方案

### 6.1 App Intents
- `DropIntent`: 打开埋藏页。
- `EmergencyTraceIntent`: 触发 SOS 流程。
- `ScanIntent`: 打开拾取页并显示附近回响摘要。

### 6.2 WidgetKit
- Small Widget：最近埋藏距离 + `+` 快捷入口。
- Medium Widget：雷达摘要 + 最近信号距离。

### 6.3 Live Activities
- `PickupTrackingAttributes`：追踪目标、距离、信号。
- 支持 `start/update/end`，并在 Pickup 流程中联动。

### 6.4 权限与隐私
- 权限引导先于系统弹窗。
- 数据本地隔离：足迹与偏好本地存储。
- SOS 本地“阅后即焚”模拟策略：完成后立即清除缓存记录。

---

## 7. 页面流程闭环（研发验收路径）

1. 首次启动：Launch -> Permission -> Empty Map。
2. Drop：Map -> Drop -> Success -> Map。
3. Pickup（公开）：Map -> Pickup -> Content。
4. Pickup（加密）：Pickup -> Passcode -> Content。
5. Pickup（时间锁）：Pickup -> TimeLockLocked。
6. SOS：Map -> BlackBox -> SOSComplete。
7. Footprints：Tab -> Footprints（有/无记录）。
8. Settings：RecoveryKey、Pro 页面都可达。
9. Widget/Intent/Live Activity 深链路均可进入对应页面。

---

## 8. 扩展与后续接入预留

### 8.1 后端接入预留
- Repository 全协议化，Mock 与 Remote 可替换。
- `DTO` 与 `Domain Model` 解耦，后续仅新增 Mapper。

### 8.2 watchOS / visionOS 预留（本期不实现）
- `Shared/Domain`、`Shared/DesignSystem` 保持跨平台无 UIKit 依赖。
- 将平台能力放在 `PlatformAdapters`，后续为 watchOS/visionOS 新增适配层。
- 文档与目录中明确预留位置，避免未来迁移成本。

---

## 9. 研发规范

1. 单文件建议不超过 200 行，按 Feature + Component 拆分。
2. 复杂 UI 用小组件拼装，禁止“超级 View 文件”。
3. 所有颜色/字号/间距必须走 Design Tokens。
4. Mock 数据不可散落在 View 内，统一在 Repository。
5. 每个核心流程至少 1 个单测或逻辑验证点。

---

## 10. 交付定义（DoD）

### 10.1 功能完成
- PRD 核心能力在 iPhone 端全部可演示。
- 所有关键页面可从主流程进入。

### 10.2 质量完成
- XcodeBuildMCP 构建通过。
- 关键逻辑测试通过。
- Widget / Live Activity 能编译并运行。

### 10.3 文档完成
- 本文档 + 实施说明落地至 `docs/design/ios/`。
- `CHANGELOG.md` 头部插入本次变更。

