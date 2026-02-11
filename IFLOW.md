# iFlow 项目配置 - Echoes

**项目名称**: 回响 (Echoes / GeoTrace)  
**项目类型**: iOS App 设计与原型开发  
**目标平台**: iOS 19+ (iPhone, Apple Watch), visionOS (可选)  
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

### 2.2 开发技术栈 (预留)
- **SwiftUI**: iOS 原生 UI 框架
- **SwiftData**: 本地数据持久化
- **Core Location**: 定位服务
- **AVFoundation**: 音频录制与播放
- **CloudKit**: 云端数据同步

### 2.3 设计规范参考
- **iOS Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines
- **Dark Mode 设计规范**: 纯黑背景 (#000000)，透明白文字
- **安全区域**: 顶部 59pt (Dynamic Island) + 44pt (导航栏)，底部 34pt (Home Indicator)

---

## 三、工作规则

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
│   └── design/           # 设计文档
│       ├── prototype-design-v1.0.md  # 原型设计文档
│       └── ui/           # UI 详细设计
│           └── ios-ui-optimization-plan.md  # iOS UI 优化方案
├── src/                  # 源代码目录 (当前为空)
├── echoes.pen            # Pencil 原型文件
├── CHANGELOG.md          # 项目变更日志
└── IFLOW.md              # 本文件
```

### 4.2 文档命名规范
- PRD: `v{版本号}.md` (如 v1.0.md)
- 设计文档: `{类型}-design-v{版本号}.md`
- UI 方案: `{平台}-ui-{描述}.md`
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

### 文件操作
```bash
# 查看项目结构
ls -la

# 查看 CHANGELOG
cat CHANGELOG.md

# 查看设计文档
cat docs/design/ui/ios-ui-optimization-plan.md
```

---

## 七、项目状态

### 当前进度
- ✅ PRD v1.0 完成
- ✅ 原型设计文档 v1.0 完成
- ✅ iOS UI 优化方案 v1.0 完成
- ✅ echoes.pen 原型文件 (6 个页面框架)
- ⏳ Widget 设计 (待完善)
- ⏳ Live Activity 设计 (待完善)
- ⏳ 动效定义 (待补充)
- ❌ 开发实现 (未开始)

### 下一步建议
1. 根据优化方案更新 echoes.pen 原型
2. 补充 Widget 和 Live Activity 设计
3. 添加启动页设计
4. 定义动效规范
5. 开始开发实现

---

**最后更新**: 2026-02-11  
**版本**: v1.1