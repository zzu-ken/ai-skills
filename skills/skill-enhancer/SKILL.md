---
name: skill-enhancer
description: 当用户要优化现有 Skills 时使用。分析用户的 Skill 文件夹，基于 Anthropic 官方规范提供优化建议和自动化改进。
version: 1.0 (2026-03-19)
---

# Skill Enhancer — 格式化增强技能

**用途：** 分析并优化用户现有的 Skills，基于 Anthropic 官方规范

**唤醒关键词：** 「为我使用 格式化增强技能 优化 xxx 技能」

---

## 核心能力

### 1. SKILL.md 结构检查

**检查项：**
```
□ 有 YAML frontmatter（name + description）
□ description 是触发条件，不是总结
□ 有 Gotchas 部分
□ 有渐进式披露（references/ 等文件夹）
□ 有代码工具（scripts/）
□ 避免过度限制（Railroading）
```

**输出：** 问题清单 + 修改建议

---

### 2. Gotchas 增强

**检查项：**
```
□ 有 Gotchas 部分
□ Gotchas 来自真实失败点
□ Gotchas 有解决方案
□ 持续更新机制
```

**优化建议：**
- 如果没有 Gotchas → 创建 GOTCHAS.md
- 如果 Gotchas 少 → 引导用户补充失败案例
- 如果 Gotchas 旧 → 提醒更新

---

### 3. 文件系统优化

**检查项：**
```
□ 有 references/ 文件夹（详细 API/签名）
□ 有 scripts/ 文件夹（自动化工具）
□ 有 assets/ 文件夹（模板文件）
□ 有 data/ 文件夹（技能内记忆）
```

**优化建议：**
- 平铺结构 → 分层结构
- 单个文件 → 渐进式披露

---

### 4. 描述字段优化

**检查项：**
```
□ description 是触发条件
□ 不是总结性描述
□ 包含使用场景
```

**错误案例：**
```yaml
description: 这是一个用于部署的技能
```

**正确案例：**
```yaml
description: 当你需要部署服务到生产环境时使用
```

---

### 5. 代码工具检查

**检查项：**
```
□ 有可执行脚本（.sh/.py）
□ 有 helper 函数库
□ 代码有注释
□ 代码可复用
```

**优化建议：**
- 如果没有代码 → 建议添加自动化脚本
- 如果代码少 → 建议添加 helper 函数

---

### 6. 记忆机制检查

**检查项：**
```
□ 有数据持久化（log/JSON/SQLite）
□ 使用 ${CLAUDE_PLUGIN_DATA} 存储
□ 有历史记录功能
```

**优化建议：**
- 如果没有记忆 → 建议添加 standups.log 类似机制
- 如果存储位置不对 → 提醒使用 ${CLAUDE_PLUGIN_DATA}

---

### 7. Hooks 检查

**检查项：**
```
□ 有 PreToolUse hooks
□ hooks 只在特定场景激活
□ hooks 有安全网功能
```

**优化建议：**
- 如果需要安全网 → 建议添加 /careful 类似 hooks

---

## 执行流程

### Step 1: 读取用户 Skill

```bash
# 定位技能文件夹
cd ~/.claude/skills/[skill-name]/
# 或
cd ./.claude/skills/[skill-name]/
```

### Step 2: 分析结构

```bash
# 检查文件结构
ls -la
# 检查 SKILL.md
cat SKILL.md
# 检查是否有 Gotchas
cat GOTCHAS.md 2>/dev/null || echo "无 Gotchas 文件"
```

### Step 3: 输出优化报告

**格式：**
```markdown
## Skill 优化报告 - [skill-name]

### ✅ 通过项
- [x] 有 YAML frontmatter
- [x] 有 Gotchas 部分

### ⚠️ 待优化项
- [ ] 无 scripts/ 文件夹 → 建议添加自动化脚本
- [ ] 无 references/ 文件夹 → 建议拆分详细 API 文档
- [ ] description 是总结 → 建议改为触发条件

### 📝 修改建议
1. 创建 scripts/check.sh 脚本
2. 创建 references/api.md 拆分详细签名
3. 修改 description 为「当你需要...时使用」

### 📁 推荐结构
[skill-name]/
├── SKILL.md
├── GOTCHAS.md
├── references/
│   └── api.md
├── scripts/
│   └── check.sh
└── assets/
    └── template.md
```

### Step 4: 自动化改进（可选）

**如果用户确认，可以：**
1. 创建 GOTCHAS.md 模板
2. 创建 references/ 文件夹
3. 创建 scripts/ 文件夹
4. 优化 SKILL.md 结构

---

## 官方规范对照表

| 官方 Tips | 检查项 | 权重 |
|-----------|--------|------|
| Don't State the Obvious | 内容是否避免显而易见 | ⭐⭐ |
| Build a Gotchas Section | 有 Gotchas 部分 | ⭐⭐⭐ |
| Use File System | 有分层文件结构 | ⭐⭐⭐ |
| Avoid Railroading | 指令不过度具体 | ⭐⭐ |
| Think through Setup | 有 config.json | ⭐ |
| Description Field | description 是触发条件 | ⭐⭐⭐ |
| Memory & Storing Data | 有数据持久化 | ⭐⭐ |
| Store Scripts | 有可执行脚本 | ⭐⭐⭐ |
| On Demand Hooks | 有 hooks | ⭐ |

**评分标准：**
- ⭐⭐⭐ 必须项（缺少则建议优化）
- ⭐⭐ 建议项（有则更好）
- ⭐ 可选（根据场景）

---

## 案例：优化 wechat-article-writer

### 优化前
```
wechat-article-writer/
├── SKILL.md
└── tools/
    └── diff-engine.js
```

### 优化后
```
wechat-article-writer/
├── SKILL.md
├── GOTCHAS.md            # 新增
├── references/           # 新增
│   ├── role-play-review.md
│   └── human-touch-checklist.md
├── scripts/              # 新增
│   ├── check-human-touch.sh
│   └── check-title.sh
├── data/                 # 新增
│   └── creation-log.jsonl
└── tools/
    └── diff-engine.js
```

### 优化点
1. ✅ 新增 GOTCHAS.md（常见失败点）
2. ✅ 新增 references/（渐进式披露）
3. ✅ 新增 scripts/（自动化工具）
4. ✅ 新增 data/（技能内记忆）
5. ✅ 优化 description（触发器导向）

---

## 输出模板

**完整报告格式：**
```markdown
## Skill 优化报告 - [skill-name]

### 基本信息
- **名称：** [name]
- **描述：** [description]
- **位置：** [path]

### 结构评分
| 维度 | 得分 | 满分 |
|------|------|------|
| SKILL.md 结构 | ✅/❌ | 1 |
| Gotchas 部分 | ✅/❌ | 1 |
| 文件系统 | ✅/❌ | 1 |
| 代码工具 | ✅/❌ | 1 |
| 记忆机制 | ✅/❌ | 1 |
| **总分** | X/5 | 5 |

### 详细检查

#### 1. SKILL.md 结构
✅ 通过 / ⚠️ 问题：[具体内容]

#### 2. Gotchas 部分
✅ 通过 / ⚠️ 问题：[具体内容]

#### 3. 文件系统
✅ 通过 / ⚠️ 问题：[具体内容]

#### 4. 代码工具
✅ 通过 / ⚠️ 问题：[具体内容]

#### 5. 记忆机制
✅ 通过 / ⚠️ 问题：[具体内容]

### 修改建议
1. [具体建议 1]
2. [具体建议 2]
3. [具体建议 3]

### 推荐结构
```
[skill-name]/
├── SKILL.md
├── GOTCHAS.md
├── references/
├── scripts/
└── data/
```

### 自动化改进
如需自动化改进，请说：「确认优化」
```

---

## 使用示例

**用户：** 为我使用 格式化增强技能 优化 wechat-article-writer 技能

**Skill Enhancer：**
```markdown
## Skill 优化报告 - wechat-article-writer

### 基本信息
- **名称：** wechat-article-writer
- **描述：** 当你要创作微信公众号文章时使用...
- **位置：** ~/.agents/skills/wechat-article-writer/

### 结构评分
| 维度 | 得分 | 满分 |
|------|------|------|
| SKILL.md 结构 | ✅ | 1 |
| Gotchas 部分 | ✅ | 1 |
| 文件系统 | ✅ | 1 |
| 代码工具 | ✅ | 1 |
| 记忆机制 | ✅ | 1 |
| **总分** | 5/5 | 5 |

### 详细检查

#### 1. SKILL.md 结构
✅ 通过：有 YAML frontmatter，description 是触发条件

#### 2. Gotchas 部分
✅ 通过：有 GOTCHAS.md，包含常见失败点

#### 3. 文件系统
✅ 通过：有 references/ scripts/ data/ 文件夹

#### 4. 代码工具
✅ 通过：有 check-human-touch.sh 和 check-title.sh

#### 5. 记忆机制
✅ 通过：有 creation-log.jsonl

### 结论
✅ 该 Skill 符合 Anthropic 官方规范，无需优化。

### 可参考的进一步优化
1. 考虑添加 hooks（如 /careful 安全网）
2. 考虑添加 config.json（用户配置）
3. 考虑添加 skill usage 统计
```

---

*创建时间：2026-03-19*
*基于：Anthropic 官方 Skills 规范（Thariq, 2026-03-19）*
