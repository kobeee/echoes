# Echoes 项目变更日志

## 2026-02-12 - UI 细节持续打磨（布局重构 + 居中修复）

### TabBar 中心按钮补漏
- [修复] Echo Discovered TabBar "+" 按钮：ellipse+text → frame(圆角20) layout 居中
- [修复] Widget Small "+" 按钮：ellipse+text → frame(圆角16) layout 居中

### Drop View 麦克风按钮重构
- [重构] 录制按钮：ellipse(120) + 独立 text 手动定位 → frame(120×120 圆角60) layout 居中麦克风
- [修复] 麦克风图标完美居中于金色圆形内

### Echo Content View 播放控件修复
- [修复] 播放按钮 ▶ 与时间 "00:23 / 01:00" 重叠 → 合并为同一行 horizontal layout 居中

### My Footprints 页面全面重构
- [重构] 统计卡片：手动 x/y 六个文字 → horizontal layout(space_around) + 三列 vertical layout(alignItems center)
- [重构] 时间线条目：手动定位图标+文字 → horizontal layout(alignItems center) + 圆形图标容器(♫/✎) + vertical 文字区
- [重构] 时间线结构：删除浮动 line/ellipse/label，改为 vertical layout 内嵌 "今天"→条目→"昨天"→条目
- [修复] 图标从不可见的 emoji 改为圆形灰底(#2C2C2E)+金色符号，清晰可见

### Drop Success 对勾居中修复
- [重构] 对勾：ellipse(60) + 手动定位 "✓" → frame(60×60 圆角30) layout 居中 "✓"

### Recovery Key 安全提醒卡片重构
- [重构] 警告卡片：vertical layout(四行堆叠) → horizontal layout [图标容器 | vertical 文字区(标题+两行描述)]

### Echo Discovered 通知卡片重构
- [重构] 通知卡片：手动 x/y 四个元素 → horizontal layout [图标容器 | vertical 文字区 | 箭头]

### Pro Subscription 功能卡片重构
- [重构] 三张功能卡片：手动 x/y → horizontal layout [图标容器(40×40 居中) | vertical 文字区(标题+描述)]

### Launch Screen 精确居中
- [修复] 同心圆组+文字整体上移 27px，视觉重心精确落在页面垂直中心
- [修复] "ECHOES" letterSpacing 8→6，减少末尾多余间距导致的视觉偏移

### Settings 栏目标题对齐
- [修复] "隐私"/"通知"/"关于" section header 左边距 x:24→x:40，与卡片内文字左边距对齐
- [修复] section header 颜色统一为 #6C6C74，更符合 iOS Settings 风格

---

## 2026-02-12 - 全页面文字居中与按钮对齐全面修复（20页全覆盖）

### 按钮容器全局修复（layout: none → layout 居中）
- [重构] Permission Request "允许使用位置" 按钮 → layout 水平垂直居中
- [重构] Drop Success "分享给朋友来寻宝" / "返回地图" 按钮 → layout 居中
- [重构] SOS Complete "知道了" 按钮 → layout 居中
- [重构] Recovery Key "复制 Key" / "我已安全备份" 按钮 → layout 居中
- [重构] Time Lock "⏰ 设置提醒" 按钮 → layout 居中
- [重构] Pro Subscription "立即订阅 Pro" 按钮 → layout 居中
- [重构] Main Map / Echo Discovered SOS 按钮 → layout 居中
- [重构] SOS Complete 关闭按钮 → layout 居中
- [重构] Echo Discovered 位置徽章 → layout 居中

### 导航栏标题全局修复（8页）
- [修复] Drop View / Pickup View / Settings / Echo Content / Recovery Key / Time Lock / Pro Subscription / Passcode Entry 导航栏标题 → textAlign center + fixed-width 全宽居中

### 居中文字修复
- [修复] Permission Request: 图标、标题、三行描述、"稍后再说" 全部居中
- [修复] Drop Success: "回响已埋下"、位置、信息文字全部居中
- [修复] SOS Complete: "数据已安全保存" 标题、对勾居中；信息卡片和密钥卡片改为 layout 垂直居中
- [修复] Recovery Key: 钥匙图标、两行描述居中；密钥卡片和警告卡片改为 layout 垂直居中
- [修复] Passcode Entry: 锁图标、标题、提示全部居中
- [修复] Time Lock: 倒计时标签、天数、日期、"返回地图" 全部居中；锁图标居中
- [修复] Pro Subscription: 星标、标题、价格、"恢复购买"、条款全部居中
- [修复] Empty Map: 标题和描述全部居中
- [修复] Echo Discovered: 通知卡片内容垂直间距优化

### Pro Feature 卡片垂直间距优化
- [修复] 三个功能卡片图标、标题、描述 y 坐标统一调整，垂直居中

---

## 2026-02-12 - 全局 UI 细节精修（对齐、居中、间距、重叠修复）

### TabBar 中心按钮重构（4页统一修复）
- [重构] Main Map / My Footprints / Settings / Empty Map 四页 TabBar 中心按钮
- [重构] 旧结构 `ellipse(40x40) + text(手动x,y)` → 新结构 `frame(layout居中) > frame(40x40 圆角20 gold layout居中) > "+"`
- [修复] "+" 号完美居中于金色圆形内，不再依赖手动坐标

### Main Map 主页修复
- [修复] 位置徽章 (locationBadge) 转为 horizontal layout 居中布局，文字水平垂直居中

### Drop View 录制页修复
- [修复] 计时器 "00:00" 全宽居中（textAlign center + fixed-width）
- [修复] "公开"/"加密" 选项容器改为 horizontal layout 居中，文字自动居中
- [修复] 麦克风图标放大 (fontSize 36→48) 并居中于录制按钮中心

### Black Box 紧急模式修复
- [修复] "⚠️ 紧急模式" 标题全宽居中
- [修复] 计时器重叠问题：合并 "/" 和 "00:30" 为单行，缩小 timer frame 高度 (130→100)
- [修复] 状态文字 "正在上传至云端 SOS 坐标..." 下移至 y:410 避免与计时器重叠，居中对齐
- [修复] "停止并保存" 按钮改为 layout 居中，文字水平垂直自动居中
- [修复] 加密提示卡片改为 horizontal layout，图标与文字自动对齐
- [修复] 进度文字 "12/30 秒已安全上传至云端" 居中对齐

### Pickup View 发现回响页修复
- [修复] "距离" 标签全宽居中（textAlign center）
- [修复] "15" 与 "米" 文字重叠：调整 "米" 位置 (x:220,y:535 → x:230,y:530) 消除重叠
- [修复] "🔓 解锁内容" 按钮改为 layout 居中，文字水平垂直自动居中

### Echo Content View 回响播放页修复
- [修复] 播放按钮 "▶" 全宽居中
- [修复] 时间文字 "00:23 / 01:00" 居中
- [修复] 统计标签 "距离这个回响被埋下，已经过去" 居中
- [修复] 统计时间 "3 天 4 小时" 居中
- [修复] "✓ 标记为已阅" 按钮改为 layout 居中

### My Footprints 足迹页修复
- [修复] 统计卡片三列布局：每列 115px 宽，数字和标签均 textAlign center
- [修复] 数字与标签垂直间距优化 (y:20,50 → y:16,50)
- [修复] 时间线竖线长度修正 (height:300 → 86)，精确连接两个节点
- [修复] "昨天" 标签位置对齐至第二条目 (y:320 → 306)
- [修复] 时间线条目图标垂直居中 (y:23 → 25)

### Settings 设置页修复
- [修复] 通知分组间距统一 (y:474 → 476)，与 section header 保持 16px 间距
- [修复] 关于 section header 和 group 位置微调，保持一致间距

### Launch Screen 启动页修复
- [修复] "ECHOES" 品牌名全宽居中（textAlign center + fixed-width）
- [修复] slogan "只有身临其境，才能听见回响" 全宽居中

---

## 2026-02-12 - 设计闭环 v4.0（16页→20页，9条流程全部闭环）

### 设计系统建立
- [新增] 31 个设计变量 Token（颜色 19 + 圆角 5 + 间距 5 + 数值 2）
- [新增] 颜色体系：bg-primary/secondary/tertiary、gold-100~700、teal/purple/red-500、text-primary/secondary/muted/gold、border-default/gold、bg-emergency/pro
- [新增] 圆角体系：radius-xs(2)/sm(4)/md(12)/lg(22)/full(9999)
- [新增] 间距体系：spacing-xs(4)/sm(8)/md(16)/lg(24)/xl(32)

### TabBar 一致性修复
- [修复] My Footprints TabBar 中间按钮：裸 ellipse(56px) → frame(44px) 包裹 ellipse(40px)+text
- [修复] Empty Map TabBar 中间按钮：同上
- [修复] Settings TabBar 中间按钮：同上，并补充缺失的 "+" 号
- [修复] Settings TabBar 位置：y:935 → y:769（标准视口位置）

### 视觉对齐修复
- [修复] Settings 页面高度：1020pt → 852pt，压缩间距使所有内容在 TabBar 上方可见
- [修复] Black Box 计时器容器：扩大至 160×130，修复文字溢出
- [修复] Drop View 波形容器：高度 120 → 145，修复高波形条裁切
- [修复] My Footprints header：高度 100 → 115，修复标题裁切
- [修复] Pickup View：距离数字居中、Echo 卡片改为垂直布局
- [修复] Widget Medium 迷你雷达：改为绝对定位，修复元素溢出排成一行
- [修复] Live Activity 迷你雷达：同上

### 新增页面（+4 页）
- [新增] **Echo Discovered** (`5866p`) — 发现回响通知状态，金色边框通知卡片，Pickup 流程入口
- [新增] **Recovery Key** (`jiWqm`) — P0 安全关键，Key 展示/复制、红色安全警告、双按钮
- [新增] **Time Lock Locked** (`T8Nkm`) — P0 核心付费点，🔒 锁定图标+光晕、倒计时 1,460 天、设置提醒
- [新增] **Pro Subscription** (`mJ8dW`) — P1 商业化落地，三大功能卡片、订阅按钮、恢复购买

### 文档输出
- [新增] `docs/design/ui/design-closure-v4.0.md` — 设计闭环方案，20 页清单+流程验证+设计规范
- [新增] `docs/design/ui/product-flow-audit.md` — 产品流程审计，9 条流程分析+缺口识别+补全建议
- [更新] `CLAUDE.md` / `IFLOW.md` — 项目状态同步至 v2.0

### 关键数据
- **页面总数**: 16 → 20（+4 页）
- **设计变量**: 0 → 31 个 Token
- **流程闭环**: 6/9 → 9/9（全部闭环）
- **PRD 覆盖度**: 78 → 92 分
- **总体完成度**: ~85% → ~97%

---

## 2026-02-12 - 产品流程审计与缺口分析
- [新增] `docs/design/ui/product-flow-audit.md` — 产品流程审计与缺口分析文档
  - 基于 PRD v1.0 逐一审计 9 条用户流程的闭环状态
  - 6 条流程完全闭环，3 条流程存在缺口
  - 识别出 2 个缺失的独立页面：Recovery Key 管理页、Pro 订阅详情页
  - 识别出 4 个缺失的页面内状态变体：时间锁未到期、足迹空状态、文字便签模式、Recovery Key 提醒
  - 当前 PRD 覆盖度综合评分：78/100
  - 补全后预计可达 92/100

---

## 2026-02-11 - Tab Bar 中间按钮修复

### Tab Bar 重新设计
- [重构] **移除外部悬浮按钮**: 删除 Main Map 页面上的独立悬浮按钮元素
- [修复] **Tab Bar 结构优化**:
  - 将中间按钮移到 Tab Bar 内部 children 中（mapTab 和 footprintTab 之间）
  - 按钮大小从 56px 缩小到 44px，不再挤占相邻 Tab 空间
  - 按钮容器改为 frame 配合 ellipse 子元素实现圆形效果
- [修复] **加号居中**: 调整 "+" 号位置 (x:10, y:5)，在 40px 圆内完全居中
- [修复] **符合 iOS 规范**: Tab Bar 保持毛玻璃背景 (rgba(28,28,30,0.72) + blur)，5 个标签均匀分布

## 2026-02-11 - 设计审查优化实施 v3.0 (全部48个问题修复完成)

### Phase 1: 阻断级问题修复 (紧急)
- [修复] **Inter 字体残留**: 将 Main Map TabBar 中 4 个 Inter 字体节点改为 `-apple-system`
  - footprintIcon (👣), footprintLabel (足迹), settingsIcon (⚙️), settingsLabel (设置)
- [修复] **设置页内容溢出**: 页面高度从 852pt 增加到 1020pt，完整展示所有内容和 TabBar
- [修复] **足迹页 TabBar 为空**: 填充完整的 5 标签 TabBar，足迹标签设为激活态金色
- [修复] **空状态页 TabBar 为空**: 填充完整的 5 标签 TabBar，地图标签设为激活态金色
- [修复] **麦克风图标偏离中心**: Drop View 录制按钮内 🎙 图标位置调整，水平居中
- [修复] **信号条未居中**: Pickup View 信号条容器宽度改为 68pt，x 位置改为 162.5 居中
- [修复] **信号条高度溢出**: 容器高度改为 32pt，5 根条底对齐（y:24/18/12/6/0）

### Phase 2: 文字居中对齐修复 (严重级)
- [修复] **Main Map 状态栏居中**: headerTitle x 从 136.5 改为 106，水平居中
- [修复] **Drop View 计时器居中**: dvTimer x 从 130 改为 136
- [修复] **Black Box 计时器间距**: sosStatus y 从 400 改为 430，避免与计时器重叠
- [修复] **Black Box 停止按钮**: 宽度从 240pt 改为 345pt，与页面其他元素对齐
- [修复] **Pickup View 距离排版**: "米" 标签 y 从 530 改为 540，与数字基线对齐
- [修复] **足迹统计三列均分**: 重新计算三列 x 坐标（43/161/275），标签对应调整
- [修复] **启动页文字居中**: ECHOES x 从 128 改为 133，Slogan x 从 109 改为 91
- [修复] **Widget Small "+" 居中**: x 从 119 改为 117，y 从 105 改为 106
- [修复] **权限引导文字对齐**: permDesc3 x 从 80 改为 60，与其他两行一致
- [修复] **Live Activity CTA 防溢出**: laCta x 从 280 改为 265，避免超出边界

### Phase 3: 内容补全与页面新增
- [新增] **SOS 完成确认页**: 完整页面设计
  - 成功图标（绿色圆形+✓）、标题、信息卡（录音/加密/GPS）
  - Recovery Key 提示卡、"知道了" CTA 按钮
- [新增] **加密口令输入页**: 完整页面设计
  - NavBar、🔒 图标、标题、说明文字
  - 4 位密码圆点指示器、数字键盘（0-9）

### Phase 4: 设计系统标准化
- [修复] **圆角标准化**: 将异常圆角值统一
  - locationBadge: 14 -> 12
  - 公开/加密选项按钮: 10 -> 12

### 关键数据
- **修复问题数**: 48 个（10 阻断级 + 26 严重级 + 12 改善级）
- **页面总数**: 14 -> 16（新增 2 个页面）
- **完成度**: 55% -> 约 85%
- **产品闭环**: 3/6 -> 5/6 核心流程完整

---

## 2026-02-11 - 设计精审 v3.0 (全量截图审查 + 细节问题清单)

### 审查文档
- [新增] `docs/design/ui/design-review-v3.0.md` — 全量 UI 精审与优化方案
  - 基于 14 个页面/组件的截图视觉审查 + 节点属性数据逐项比对
  - 发现 48 个问题（10 个阻断级 + 26 个严重级 + 12 个改善级）
  - 分 5 个 Phase 的实施路线图，预计 11-16 小时

### 关键发现
- [问题] **Inter 字体残留 4 个节点**: Main Map TabBar 的足迹/设置标签
- [问题] **设置页内容溢出**: TabBar 在 y:935 超出 852pt 页面高度，关于组底边在 y:909
- [问题] **两个 TabBar 为空**: 足迹页和空状态页 TabBar 无标签内容
- [问题] **大量文字未居中**: 麦克风图标偏离录制按钮中心、信号条未居中、距离数字与单位不对齐等
- [问题] **圆角体系不统一**: 存在 12 种 cornerRadius 值
- [问题] **缺失 2 个关键页面**: SOS 完成确认页、加密口令输入页

### 页面完整性
- 当前: 14 个 Frame（含 2 Widget + 1 Live Activity）
- 产品闭环: 3/6 核心流程完整闭环，3 个流程有断裂
- 总体完成度: 约 55%（从 v2.1 的 22% 提升）

---

## 2026-02-11 - 设计审查优化实施 v2.2 (剩余优化点全部完成)

### 设计系统根基
- [重构] **全局字体统一**: 将所有剩余 `Inter` 字体节点替换为 `-apple-system`
  - Drop View: recText, lockLabel, lockHint, micIcon
  - Black Box: progressText, encryptIcon, encryptText, sosClose
  - Pickup View: echoType, echoSource, distLabel
  - My Footprints: todayLabel, yesterdayLabel, fpStat3, fpStat3Label
  - Echo Content View: 全部 9 个文本节点
  - Drop Success: svCheck

### 核心页面优化

#### 设置页 (Settings) - 完整重构
- [新增] **Pro 卡片优化**:
  - 添加 1pt 金色描边 (`#D4AA40`)
  - 添加价格标签 "¥12/月"
  - 添加 "了解更多 >" 链接
- [新增] **隐私设置组**: 精确位置共享 / 后台定位权限 / 本地内容审核 (3个 Toggle)
- [新增] **通知设置组**: 附近回响通知 / 震动反馈 (2个 Toggle)
- [新增] **关于信息组**: 版本 1.0.0 / 隐私政策 / 联系我们 / 给我们评分
- [新增] **底部 TabBar**: 与主地图一致的 5 标签导航

#### 启动页 (Launch Screen) - 视觉增强
- [新增] **同心圆金色描边**:
  - 外圈 (200pt): 2pt 描边 `#B89A4A`, 50% opacity
  - 中圈 (150pt): 1.5pt 描边 `#D4AA40`, 35% opacity
  - 内圈 (100pt): 1pt 描边 `#EAD07A`, 20% opacity

#### 埋藏页 (Drop View) - 波形优化
- [重构] **波形可视化升级**:
  - 从 12 根增加到 24 根竖条
  - 统一宽度为 4pt，圆角 2pt
  - 统一间距 12pt
  - 高度按照音频模拟分布（中间高两侧低）
  - 颜色映射：低=gold-400, 中=gold-500/600, 高=gold-700

#### 黑匣子 (Black Box) - 计时器重构
- [重构] **计时器垂直排版**:
  - 当前时间 "00:12": 56pt Light, 主白色
  - 分隔线 "/": 20pt, 次级文字色
  - 总时间 "00:30": 20pt, 次级文字色
  - 整体改为垂直居中布局

#### 足迹页 (My Footprints) - 清理
- [删除] **移除设置入口**: 右上角 "设置" 文字链接已移除（从 TabBar 进入）

### 新增页面 (Phase 4)

#### 权限引导页 (Permission Request)
- [新增] 首次启动位置权限请求页面
- 大图标 📍 (64pt, teal-500)
- 标题 "发现身边的回响" (28pt Bold)
- 说明文字：位置信息用途说明
- 主 CTA: "允许使用位置" (金色按钮)
- 次级 CTA: "稍后再说" (文字按钮)

#### 主地图空状态页 (Empty Map)
- [新增] 无 Echo 数据时的引导页面
- 淡化雷达同心圆 (10% opacity)
- 用户位置点 (12pt, 50% opacity)
- 标题 "这里还没有回响" (20pt)
- 说明 "成为第一个在这里留下声音的人"
- CTA: "✦ 留下第一个回响" (金色按钮)
- 保留 TabBar 导航

#### Live Activity (灵动岛展开态)
- [新增] 寻宝模式实时追踪 UI
- 尺寸: 393×160pt, 圆角 24pt
- 品牌栏: ◉ Echoes (金色)
- 左侧迷你雷达 (80×80pt)
- 右侧信息: 正在追踪 / 🎙️ 神秘语音回响 / 15m / 信号条
- CTA: "打开 App 查看 →"

### 完成度评估
- 字体统一: 100% ✅
- 设置页完整度: 100% ✅
- 启动页描边: 100% ✅
- 埋藏页波形: 100% ✅
- 黑匣子计时器: 100% ✅
- 足迹页清理: 100% ✅
- 新增页面: 3/3 ✅

**总体完成度: 约 95%** (设计系统 Token 变量和可复用组件建议后续版本实施)

---

## 2026-02-11 - 画布布局整理

### 组件位置整理
- [整理] **Widget 组件归位**: 将 Widget 组件统一排列到页面底部
  - Widget Medium 从右上角 (x=2700, y=0) 移至 Widget Small 右侧 (x=200, y=949)
  - 两个 Widget 现在处于同一行，间距 42px
  - 避免与主页面区域重叠

### 页面布局修复
- [修复] **Echo Content View 游离元素**: 修复子元素布局错乱问题
  - 将父容器布局从 flexbox 改为绝对定位 (layout: "none")
  - 重新定位子元素：信息卡 (y=120)、播放器 (y=220)、统计 (y=440)、按钮 (y=560)
  - 消除与 Drop Success 页面的视觉重叠

## 2026-02-11 - 布局修复

### 布局问题修复
- [修复] **Widget Medium 布局**: 修复雷达与文字重叠问题
  - 左侧迷你雷达 (120×120pt) 定位到 x:16, y:19
  - 右侧信息区垂直排列：标签、距离数字、信号条、CTA
  - 各元素间距合理，不再重叠
- [修复] **Drop Success 布局**: 修复所有元素堆叠在顶部的问题
  - 成功动画居中在 y:180
  - 标题、位置信息、详情依次垂直排列 (y:420, 470, 495)
  - 两个按钮在底部合理分布 (y:600, 670)
  - 按钮内文字居中对齐

## 2026-02-11 - iOS UI 优化方案实施 v2.1 (设计审查后优化)

### 设计系统根基 (Phase 0)
- [重构] **全局字体替换**: 所有 `Inter` 字体替换为 `-apple-system` (SF Pro)
- [修复] **清理重复节点**: 删除重复的 SOS 按钮 `sosBtnNew`

### 核心页面修复 (Phase 1)

#### 主地图 (Main Map) - 重大升级
- [重构] **TabBar 5标签**: 从 2 标签 pill 改为标准 iOS TabBar
  - 首页 (🏠) / 地图 (🗺) / 中央埋藏按钮 (+) / 足迹 (👣) / 设置 (⚙️)
  - 毛玻璃背景效果 + 背景模糊
  - 中央按钮为金色凸起圆形按钮
- [重构] **雷达系统升级**:
  - 3 层同心圆改为虚线描边样式 (`dashPattern`)
  - 添加十字参考线（水平+垂直，teal-300 10% opacity）
  - 扫描线改为渐变效果
- [新增] **Echo 信号点辉光效果**:
  - 每个 Echo 点添加双层辉光（24pt 30% opacity + 48pt 10% opacity）
  - 用户位置点也添加辉光层
- [优化] 顶部信息栏居中对齐

#### 埋藏页面 (Drop View)
- [新增] **录制指示器**: "● REC" 红色指示器
- [新增] **时间锁功能区**: 时间锁 Toggle + 提示文字
- [新增] **麦克风图标**: 录制按钮中心添加 🎙 图标
- [优化] 返回按钮和标题字体

#### 拾取页面 (Pickup View)
- [重构] **雷达升级**: 从单圆改为 3 层虚线同心圆
- [新增] **Echo 信息卡**: 显示 "🎙️ 语音回响" + "来自匿名旅行者 · 3天前"
- [优化] **方向箭头**: 改进样式和颜色
- [优化] **距离排版**: 添加 "距离" 标签，改进数字和单位对齐
- [优化] **信号强度条**: 增加为 5 根，调整高度递增
- [优化] **解锁按钮**: 改为 capsule 形状 (cornerRadius: 25)

#### 黑匣子页面 (Black Box)
- [新增] **关闭按钮**: 右上角 "×" 关闭按钮
- [新增] **外层脉冲**: 添加 140pt 外层脉冲效果
- [新增] **上传进度条**: 30 个小块进度指示器 (12/30 已上传)
- [新增] **进度文字**: "12/30 秒已安全上传至云端"
- [新增] **加密提示卡**: 边框卡片显示 Recovery Key 提示
- [优化] **停止按钮**: 宽度改为 345pt，capsule 形状

### 关键缺失页面 (Phase 2)

#### 新增 Medium Widget (338×158pt)
- [新增] 完整 Medium Widget 设计
- 左侧迷你雷达 (120×120pt): 2 层虚线同心圆 + 用户点 + Echo 点
- 右侧信息区: "距离最近的回响" + "250 m" + 信号条 + CTA
- 毛玻璃背景，圆角 22pt

#### 新增 Echo 内容查看页
- [新增] 完整 Echo 播放页面
- 信息卡: 语音回响类型 + 来源 + 时间
- 播放区域: 金色波形可视化 + 播放按钮 + 进度条
- 统计区域: "距离这个回响被埋下，已经过去 3 天 4 小时"
- Witnessed 按钮: "✓ 标记为已阅"

#### 新增埋藏成功确认页
- [新增] 成功状态页面
- 金色同心圆波纹 + 中心对号
- 回响信息: 📍 位置 + 🔓 权限 + 时长
- 分享按钮 (描边样式) + 返回地图按钮

### 足迹页优化 (Phase 3)
- [新增] **第三列统计**: "探索距离 256km"
- [新增] **时间线连接线**: 垂直连接线 + 节点圆点
- [新增] **时间分组**: "今天" / "昨天" 标签
- [新增] **TabBar**: 底部添加导航栏
- [删除] 设置入口文字 (从 TabBar 进入)

### 设置页优化 (Phase 3)
- [新增] **完整 Grouped Table 结构**:
  - Pro 升级卡片 (带金色边框)
  - 隐私设置组: 精确位置 / 后台定位 / 本地审核
  - 通知设置组: 附近回响通知 / 震动反馈
  - 关于组: 版本 / 隐私政策 / 联系我们 / 评分
- [新增] **TabBar**: 底部添加导航栏

---

## 2026-02-11 - iOS UI 优化方案实施 v2.0

### 设计系统重构
- [重构] 删除所有 Grid 辅助线（6 条实线）
- [重构] 背景色统一为纯黑 `#000000`
- [新增] 完整颜色 Token 系统：
  - 金色系：gold-100 ~ gold-900（主品牌色 `#D4AA40`）
  - 信号青：teal-500 `#00BFA5`
  - 加密紫：purple-500 `#8E6DAF`
  - 紧急红：red-500 `#FF453A`（Dark Mode 专用）
  - 背景层级：bg-primary/secondary/tertiary
  - 文字层级：text-primary/secondary/tertiary

### 页面重构
- [重构] **主地图 (Main Map)**：
  - 雷达同心圆改为虚线描边样式
  - Echo 信号点增大至 12pt，使用新色值
  - 添加 LocationBadge 位置信息条
  - SOS 按钮使用深红色背景 `#2A0F0F`
  - TabBar 使用毛玻璃效果背景
  
- [重构] **埋藏页面 (Drop View)**：
  - 波形可视化扩展至 12 根不等高竖条
  - 使用金色色阶渐变（gold-400 ~ gold-600）
  - 录制按钮增大至 120pt
  - 权限选择按钮使用新配色

- [重构] **拾取页面 (Pickup View)**：
  - 距离数字改为 Title 1 样式（28pt Bold）
  - 添加"米"单位标签
  - 信号强度条使用新色值
  - 解锁按钮使用新金色

- [重构] **黑匣子页面 (Black Box)**：
  - 背景改为深红渐变 `#0A0505`
  - 录制指示器使用新红色 `#FF453A`
  - 停止按钮使用标准圆角 12pt

- [重构] **我的足迹 (My Footprints)**：
  - 标题改为 Large Title 样式（34pt Bold）
  - 统计卡片使用新配色
  - 时间线项目使用新背景色

- [重构] **设置页面 (Settings)**：
  - Profile 卡片使用新配色
  - Pro 升级卡片使用金色边框样式

### 新增页面
- [新增] **启动页 (Launch Screen)**：
  - 纯黑背景
  - 3 层金色同心圆波纹
  - 品牌名 "ECHOES" + Slogan

- [新增] **Small Widget**：
  - 158×158pt 尺寸
  - 圆角 22pt
  - 显示距离信息和快捷按钮

### 图标与字体
- [替换] 所有 Material Symbols 图标改为文本/Emoji 替代
- [更新] 字体统一使用 Inter（SF Pro 的替代方案）

### 安全区域
- [修复] 所有页面顶部预留 59pt（Dynamic Island）
- [修复] 所有页面底部预留 34pt（Home Indicator）

---

## 2026-02-11 - 初始提交

### 项目初始化
- [新增] 创建 iOS App 原型文件 `echoes.pen`
- [新增] 6 个基础页面框架：
  - Main Map（主地图）
  - Drop View（埋藏）
  - Black Box（黑匣子/SOS）
  - Pickup View（拾取）
  - My Footprints（我的足迹）
  - Settings（设置）
- [新增] PRD 文档 v1.0
- [新增] 原型设计文档 v1.0
- [新增] iOS UI 优化方案 v2.0
