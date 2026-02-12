# Echoes 产品流程审计与缺口分析

**版本**: v1.0
**日期**: 2026-02-12
**基于**: PRD v1.0 + 当前 16 个页面
**审计目标**: 验证所有用户流程是否闭环，识别缺失页面/状态/交互

---

## 一、当前页面清单（16 个）

| # | 页面名称 | 英文名 | 类型 |
|---|---------|--------|------|
| 1 | 主地图 | Main Map | 核心页 |
| 2 | 埋藏页面 | Drop View | 核心页 |
| 3 | 黑匣子 | Black Box | 核心页 |
| 4 | 拾取页面 | Pickup View | 核心页 |
| 5 | 我的足迹 | My Footprints | 核心页 |
| 6 | 设置 | Settings | 核心页 |
| 7 | 启动页 | Launch Screen | 系统页 |
| 8 | 小组件 | Widget Small | 系统集成 |
| 9 | 中组件 | Widget Medium | 系统集成 |
| 10 | 回响内容查看 | Echo Content View | 详情页 |
| 11 | 埋藏成功 | Drop Success | 反馈页 |
| 12 | 权限请求 | Permission Request | 引导页 |
| 13 | 空状态地图 | Empty Map | 空状态 |
| 14 | 灵动岛 | Live Activity | 系统集成 |
| 15 | SOS 完成确认 | SOS Complete | 反馈页 |
| 16 | 加密口令输入 | Passcode Entry | 交互页 |

---

## 二、用户流程地图

### Flow 1: 首次启动流程
```
[Launch Screen] → [Permission Request (位置/麦克风/通知)] → [Main Map (Empty Map)]
```

**涉及页面**: Launch Screen → Permission Request → Empty Map / Main Map
**闭环状态**: ✅ 已闭环
**说明**: 启动页 → 权限引导 → 空状态地图（首次无数据）→ 正常地图（有数据后）。流程完整。

**细节检查**:
- ✅ 启动页（#7）存在
- ✅ 权限请求页（#12）存在
- ✅ 空状态地图（#13）存在
- ⚠️ 权限请求是否覆盖三步引导（位置→麦克风→通知）？当前仅 1 个页面，需确认是否为多步骤设计或单页面内切换。如果是单页面内切换 tab 则无问题。

---

### Flow 2: 埋藏流程 (The Drop)

```
[Main Map] → 点击"+"或按住说话 → [Drop View] → 录制/输入 → 设置权限(公开/加密)
  ├─ 公开 → 确认埋藏 → [Drop Success] → 返回 [Main Map]
  └─ 加密 → 输入口令 → 确认埋藏 → [Drop Success] → 返回 [Main Map]
```

**涉及页面**: Main Map → Drop View → Drop Success → Main Map
**闭环状态**: ✅ 基本闭环
**说明**: 核心埋藏流程完整。录制、权限设置、成功反馈均有对应页面。

**细节检查**:
- ✅ Drop View（#2）存在，包含录制和权限设置
- ✅ Drop Success（#11）存在
- ⚠️ **文字便签模式**: PRD 明确支持"文字便签"作为轻量级内容形式，Drop View 需要有文字输入模式的切换（语音/文字 Tab）。这是页面内状态，不需要独立页面，但视觉稿需要体现。
- ⚠️ **时间锁设置**: PRD 核心付费点。Drop View 内应有时间锁折叠区域。UI 优化方案已规划，需确认视觉稿是否体现。
- ⚠️ **录制中状态**: Drop View 的录制进行时视觉（红色脉冲、波形动画）。属于页面内状态变化，不需要独立页面。

---

### Flow 3: 拾取流程 (The Pickup)

```
[Main Map] → 点击信号点/收到通知 → [Pickup View] → 走近目标
  ├─ 公开 Echo → 距离足够近 → 解锁 → [Echo Content View]
  ├─ 加密 Echo → 距离足够近 → [Passcode Entry] → 正确 → [Echo Content View]
  │                                              → 错误 → 错误反馈(页面内)
  └─ 时间锁 Echo → 未到期 → ❌ 缺少"时间锁未到期"状态
                  → 已到期 → 正常解锁流程
```

**涉及页面**: Main Map → Pickup View → Passcode Entry → Echo Content View
**闭环状态**: ⚠️ 基本闭环，有 1 个缺口

**细节检查**:
- ✅ Pickup View（#4）存在
- ✅ Passcode Entry（#16）存在
- ✅ Echo Content View（#10）存在
- ❌ **时间锁未到期状态**: 用户发现一个设有时间锁的 Echo，但尚未到开启时间。需要展示"还有 X 天/年才能打开"的状态。这可以是 Pickup View 内的一个状态变体，不需要独立页面，但视觉稿必须体现。
- ⚠️ **已阅标记交互**: PRD 提到拾取后仅限"已阅（Witnessed）"标记。Echo Content View 内是否有此交互？需确认。

---

### Flow 4: SOS/黑匣子流程

```
[Main Map] → 长按 SOS 按钮(1秒) → [Black Box] → 录制中(自动分片上传)
  ├─ 录制完成(30秒到) → [SOS Complete] → 返回 [Main Map]
  └─ 手动停止 → [SOS Complete] → 返回 [Main Map]
```

**涉及页面**: Main Map → Black Box → SOS Complete → Main Map
**闭环状态**: ✅ 已闭环

**细节检查**:
- ✅ Black Box（#3）存在
- ✅ SOS Complete（#15）存在
- ⚠️ **Recovery Key 展示**: SOS Complete 页面是否展示/提醒用户 Recovery Key？PRD 强调"只能通过 Recovery Key 在网页端找回"，SOS 完成后必须提醒用户保存 Key。这是 SOS Complete 页面内的关键信息，不需要独立页面。
- ⚠️ **上传失败状态**: 网络异常时的降级处理。Black Box 页面内应有失败/重试状态。

---

### Flow 5: 足迹浏览流程

```
[TabBar 足迹] → [My Footprints]
  ├─ 有记录 → 浏览时间线 → 点击某条 → [Echo Content View]
  └─ 无记录 → ❌ 缺少足迹空状态
```

**涉及页面**: My Footprints → Echo Content View
**闭环状态**: ⚠️ 有 1 个缺口

**细节检查**:
- ✅ My Footprints（#5）存在
- ✅ Echo Content View（#10）复用
- ❌ **足迹空状态**: 首次使用无任何记录时的引导页面。UI 优化方案已设计，但当前 16 页中未包含。可以是 My Footprints 页面内的条件渲染，但视觉稿需要体现。
- ⚠️ **足迹地图全屏**: UI 优化方案提到"查看完整足迹地图"入口，但这属于增强功能，v1 可不做独立页面。

---

### Flow 6: 设置流程

```
[TabBar 设置] → [Settings]
  ├─ Profile / Device ID → 页面内展示
  ├─ Recovery Key → ❌ 缺少 Recovery Key 查看/备份页面
  ├─ 隐私开关 → 页面内 Toggle
  ├─ Pro 订阅 → ❌ 缺少 Pro 订阅详情/购买页面
  ├─ 隐私政策 → 外部 WebView (不需要设计)
  └─ 关于/版本 → 页面内展示
```

**涉及页面**: Settings
**闭环状态**: ⚠️ 有 2 个缺口

**细节检查**:
- ✅ Settings（#6）存在
- ❌ **Recovery Key 管理页**: PRD 将 Recovery Key 定位为 SOS 数据找回的唯一凭证，这是安全关键功能。用户需要能查看、复制、备份自己的 Recovery Key。需要独立页面或 Sheet。
- ❌ **Pro 订阅详情页**: PRD 商业化模块定义了三级付费体系（免费/存储付费/Pro 订阅）。Settings 中的"了解更多"需要跳转到订阅详情页，展示功能对比和购买入口。需要独立页面。

---

### Flow 7: Widget 交互流程

```
[Widget Small] → 点击"+" → Deep Link → [Drop View]
[Widget Medium] → 点击"开始寻宝" → Deep Link → [Main Map] / [Pickup View]
```

**涉及页面**: Widget Small / Widget Medium → App 内页面
**闭环状态**: ✅ 已闭环
**说明**: Widget 作为入口，通过 Deep Link 跳转到 App 内对应页面。流程完整。

---

### Flow 8: Live Activity 流程

```
追踪模式激活 → [Live Activity (灵动岛)]
  ├─ Minimal: 小圆点指示
  ├─ Compact: 距离 + 方向
  ├─ Expanded: 点击展开 → 微型雷达 + 详情
  └─ 点击 → Deep Link → [Pickup View]
```

**涉及页面**: Live Activity → Pickup View
**闭环状态**: ✅ 已闭环
**说明**: UI 优化方案定义了 4 种状态（Minimal/Compact/Expanded/Lock Screen）。当前 Live Activity（#14）需确认是否覆盖所有状态变体。

---

### Flow 9: 被动感知流程 (后台发现)

```
App 后台运行 → Core Location 地理围栏触发 → 系统通知/Watch 震动
  → 用户点击通知 → [Pickup View] → 正常拾取流程
```

**涉及页面**: 系统通知 → Pickup View
**闭环状态**: ✅ 已闭环
**说明**: 被动感知依赖系统通知，不需要额外页面设计。通知点击后进入 Pickup View。

---

## 三、流程闭环评估总表

| 流程 | 状态 | 缺口数 | 说明 |
|------|------|--------|------|
| Flow 1: 首次启动 | ✅ 闭环 | 0 | 完整 |
| Flow 2: 埋藏 | ✅ 闭环 | 0 | 页面内状态需完善（文字模式、时间锁） |
| Flow 3: 拾取 | ⚠️ 有缺口 | 1 | 时间锁未到期状态缺失 |
| Flow 4: SOS | ✅ 闭环 | 0 | Recovery Key 提醒需在 SOS Complete 内体现 |
| Flow 5: 足迹 | ⚠️ 有缺口 | 1 | 足迹空状态缺失 |
| Flow 6: 设置 | ⚠️ 有缺口 | 2 | Recovery Key 页 + Pro 订阅页缺失 |
| Flow 7: Widget | ✅ 闭环 | 0 | 完整 |
| Flow 8: Live Activity | ✅ 闭环 | 0 | 需确认多状态覆盖 |
| Flow 9: 被动感知 | ✅ 闭环 | 0 | 依赖系统通知 |

---

## 四、缺失页面/状态清单
### 4.1 需要新增的独立页面（2 个）

| # | 页面名称 | 所属流程 | 优先级 | 理由 |
|---|---------|---------|--------|------|
| N1 | **Recovery Key 管理页** | Flow 6 设置 | 🔴 高 | PRD 将 Recovery Key 定位为 SOS 数据找回的唯一凭证。用户必须能查看、复制、备份。无此页面，SOS 功能的安全承诺无法兑现。 |
| N2 | **Pro 订阅详情页** | Flow 6 设置 | 🟡 中 | PRD 商业化模块的核心入口。需展示免费版 vs Pro 功能对比、价格、购买按钮。无此页面，付费转化无着陆点。 |

### 4.2 需要补充的页面内状态变体（4 个）

这些不需要独立页面，但视觉稿中必须体现为对应页面的状态变体：

| # | 状态名称 | 所属页面 | 优先级 | 理由 |
|---|---------|---------|--------|------|
| S1 | **时间锁未到期状态** | Pickup View | 🔴 高 | 时间锁是 PRD 核心付费点。用户发现时间锁 Echo 但未到期时，需要明确的"倒计时"展示，否则用户会困惑为什么无法打开。 |
| S2 | **足迹空状态** | My Footprints | 🟡 中 | 首次使用无记录时的引导。UI 优化方案已设计，需落地到视觉稿。 |
| S3 | **文字便签输入模式** | Drop View | 🟡 中 | PRD 明确支持文字便签。Drop View 需要语音/文字模式切换的视觉表达。 |
| S4 | **Recovery Key 提醒** | SOS Complete | 🟡 中 | SOS 完成后必须提醒用户 Recovery Key 信息，否则数据可能永远无法找回。 |

### 4.3 不建议新增的页面

以下是审计中考虑过但认为不必要的页面：

| 页面 | 不建议理由 |
|------|-----------|
| Onboarding 引导教程 | PRD 未要求。产品足够简单（埋藏+拾取），Permission Request 已承担引导职责。过度引导反而违背"极简主义"理念。 |
| 足迹地图全屏 | v1 阶段 My Footprints 的时间线已足够。全屏地图是增强功能，可在 v2 迭代。 |
| Siri Snippet 卡片 | 系统级 UI，由 iOS 自动渲染，不需要在原型中设计。 |
| 上传失败/重试页 | 应在 Black Box 页面内处理（Toast/Banner），不需要独立页面。 |
| 通知设置详情页 | Settings 内的 Toggle 已足够，不需要二级页面。 |
| 删除确认弹窗 | 使用 iOS 标准 ActionSheet，不需要自定义页面。 |

---

## 五、优先级排序的补全建议

### P0 - 必须补全（影响核心流程闭环）

**1. Recovery Key 管理页**
- 类型: 新增独立页面
- 入口: Settings → Profile 卡片 → Recovery Key
- 内容:
  - Recovery Key 展示（遮罩/显示切换）
  - 复制到剪贴板按钮
  - "已安全备份"确认按钮
  - 安全提示: "这是找回 SOS 数据的唯一凭证，请妥善保管"
- 设计风格: 与 Settings 一致的 Grouped Table 风格，强调安全感

**2. 时间锁未到期状态（Pickup View 变体）**
- 类型: 页面内状态变体
- 触发: 用户发现一个设有时间锁且未到期的 Echo
- 内容:
  - Echo 信息卡片（类型、创建者、加密状态）
  - 大号倒计时: "还有 1,460 天" / "2030年1月1日开启"
  - 锁定图标动画（lock.fill + 金色光晕）
  - "设置提醒"按钮（到期时推送通知）
- 视觉: 整体偏冷色调（区别于可解锁的暖色调），锁定感

### P1 - 应该补全（影响产品完整度）

**3. Pro 订阅详情页**
- 类型: 新增独立页面
- 入口: Settings → Pro 卡片 → "了解更多"
- 内容:
  - 功能对比表（免费 vs Pro）
  - 价格: ¥12/月
  - 核心卖点: 秘密地图、无限视频、金色光点
  - 购买按钮（调用 StoreKit）
  - 恢复购买链接
- 设计风格: 金色主题，突出高级感

**4. 足迹空状态（My Footprints 变体）**
- 类型: 页面内状态变体
- 触发: 用户首次进入足迹页，无任何记录
- 内容: UI 优化方案已设计（大图标 + 引导文字 + CTA 按钮）
- 直接按 ios-ui-optimization-plan.md 5.4 节实施即可

**5. 文字便签输入模式（Drop View 变体）**
- 类型: 页面内状态变体
- 触发: Drop View 顶部切换 Tab（语音/文字）
- 内容:
  - 文字输入区域（多行，bg-tertiary 背景）
  - 字数限制提示（如 500 字）
  - 其余（权限、时间锁、确认按钮）与语音模式共用

### P2 - 建议补全（提升体验完善度）

**6. Recovery Key 提醒（SOS Complete 增强）**
- 类型: 现有页面增强
- 内容: 在 SOS Complete 页面底部增加 Recovery Key 提示卡片
- 包含: Key 前 4 位 + "****" 遮罩 + "查看完整 Key" 链接

---

## 六、PRD 功能覆盖度评分

### 模块覆盖度

| PRD 模块 | 覆盖度 | 说明 |
|---------|--------|------|
| 模块1: 埋藏 (The Drop) | 85% | 核心流程完整。文字便签模式视觉稿待补充，时间锁 UI 待确认。 |
| 模块2: 拾取 (The Pickup) | 80% | 核心流程完整。时间锁未到期状态缺失，已阅标记交互待确认。 |
| 模块3: 黑匣子 (SOS) | 90% | 流程闭环。Recovery Key 提醒需在 SOS Complete 中强化。 |
| 系统集成: Widget | 95% | Small + Medium 两种尺寸均有。 |
| 系统集成: Live Activity | 85% | 存在但需确认是否覆盖 4 种状态变体。 |
| 系统集成: Siri | N/A | Siri 交互由系统渲染，不需要原型页面。 |
| 商业化 | 50% | Settings 中有 Pro 卡片入口，但缺少订阅详情页和购买流程。 |
| 隐私与安全 | 70% | Settings 有隐私开关，但 Recovery Key 管理页缺失。 |

### 总体评分

| 维度 | 评分 | 说明 |
|------|------|------|
| 页面覆盖度 | **82/100** | 16 个页面覆盖了 PRD 的主要功能，缺 2 个独立页面 |
| 流程闭环度 | **78/100** | 9 条流程中 6 条完全闭环，3 条有缺口但不致命 |
| 状态完整度 | **72/100** | 缺少 4 个关键状态变体（时间锁、空状态、文字模式、Key 提醒） |
| PRD 功能覆盖 | **80/100** | 核心功能覆盖良好，商业化和安全模块偏弱 |
| **综合评分** | **78/100** | 产品骨架完整，需补全 2 个页面 + 4 个状态变体即可达到 90+ |

---

## 七、补全后的完整页面清单（18 个页面 + 4 个状态变体）

### 独立页面（18 个）

| # | 页面 | 状态 |
|---|------|------|
| 1-16 | 现有 16 个页面 | ✅ 已有 |
| 17 | Recovery Key 管理页 | 🆕 新增 |
| 18 | Pro 订阅详情页 | 🆕 新增 |

### 状态变体（标注在对应页面视觉稿中）

| # | 变体 | 所属页面 | 状态 |
|---|------|---------|------|
| V1 | 时间锁未到期 | Pickup View | 🆕 新增 |
| V2 | 足迹空状态 | My Footprints | 🆕 新增 |
| V3 | 文字便签模式 | Drop View | 🆕 新增 |
| V4 | Recovery Key 提醒 | SOS Complete | 🆕 增强 |

---

**结论**: 当前 16 个页面的产品骨架是扎实的，核心的"埋藏-拾取"闭环已经成立。缺口集中在两个方面：一是安全相关的 Recovery Key 管理（这是 PRD 安全承诺的兑现），二是商业化的 Pro 订阅落地页。补全 2 个新页面 + 4 个状态变体后，PRD 覆盖度可从 78 分提升至 92 分以上。建议优先处理 P0 级别的 Recovery Key 管理页和时间锁未到期状态。
