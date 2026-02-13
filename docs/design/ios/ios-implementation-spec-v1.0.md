# Echoes iOS 实施规格 v1.0

**日期**: 2026-02-13  
**对应文档**: `ios-rd-master-plan-v1.0.md`

## 1. 技术基线
- Swift 6 + SwiftUI
- iOS Deployment Target: `19.0`（若工具链限制则降级到可编译最低值并在 Changelog 记录）
- 构建体系：Xcode Project（位于 `src/ios/EchoesApp`）

## 2. Feature 模块拆分

```text
Features/
  Launch/
  Permissions/
  Map/
  Drop/
  Pickup/
  BlackBox/
  Footprints/
  Settings/
  Pro/
```

每个模块统一结构：
- `Views/`
- `ViewModels/`
- `Models/`
- `Components/`

## 3. 关键模型

### 3.1 Echo
- `id`
- `title`
- `kind`（voice/text/video）
- `visibility`（public/private）
- `distanceMeters`
- `timeLockDate`
- `passcode`
- `isWitnessed`

### 3.2 Footprint
- `id`
- `createdAt`
- `locationName`
- `echoType`
- `summary`

### 3.3 SOSRecord
- `id`
- `startedAt`
- `duration`
- `progress`
- `recoveryKey`
- `uploadedChunks`

## 4. 路由与深链路

统一路由枚举 `AppRoute`：
- `.tab(AppTab)`
- `.drop`
- `.pickup(echoId)`
- `.echoContent(echoId)`
- `.blackBox`
- `.sosComplete`
- `.recoveryKey`
- `.proSubscription`
- `.timeLock(echoId)`
- `.passcode(echoId)`

统一深链路：
- `echoes://drop`
- `echoes://pickup`
- `echoes://sos`
- `echoes://pro`

## 5. 视觉还原策略

1. 先实现布局骨架（安全区、边距、TabBar）。
2. 再对齐配色、字号、层级和组件样式。
3. 最后补齐动画和触觉反馈。

还原优先级：
- P0：主流程页面（Map/Drop/Pickup/SOS/Settings）
- P1：补全页（Passcode/Recovery/TimeLock/Pro）
- P2：Widget + Live Activity + Intent 入口

## 6. Mock 服务边界

Repository 协议定义在 `Shared/Domain/Protocols`：
- 不允许直接在 ViewModel 写死数组。
- 所有可变状态走 Repository -> UseCase。

持久化策略：
- 本期：`UserDefaults + 内存`。
- 下期替换：`CloudKit/HTTP` 实现相同协议。

## 7. 测试计划

### 7.1 单测
- Passcode 校验
- Time Lock 到期判断
- Witness 标记流程
- SOS 进度状态机

### 7.2 构建验证
- 主 App `build_sim`
- Tests `test_sim`
- Widget Extension 编译通过
- Live Activity 编译通过

## 8. 风险与控制

1. **Widget 与 Intent 依赖编译风险**  
   处理：将 Intent 放共享文件并明确 target membership。

2. **Live Activity 状态同步复杂**  
   处理：使用单一 ActivityManager，禁用并发多活动。

3. **页面数量大导致文件膨胀**  
   处理：严格组件化，小文件拆分（目标 < 200 行/文件）。

## 9. 交付物清单

1. `src/ios/EchoesApp` 完整 Xcode 工程源码
2. `docs/design/ios` 设计与实施文档
3. `CHANGELOG.md` 头部新增本次研发记录
4. XcodeBuildMCP 验证结果（构建 + 测试）

