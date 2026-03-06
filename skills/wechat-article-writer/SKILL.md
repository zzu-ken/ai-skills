---
name: wechat-article-writer
description: Multi-agent workflow for generating WeChat public account articles (微信公众号推文). Fetches source articles, searches hot news and supplementary data via internet, rewrites with original perspectives, and polishes through editorial review. Use when user asks to write, rewrite, or generate a WeChat article, 公众号推文, or Chinese content article from a URL, text, or topic keyword. Supports two modes — article-based rewrite and keyword-driven generation — with integrated web search for trending news.
---

# WeChat Article Writer v2

Multi-agent workflow to produce polished WeChat public account articles (微信公众号推文) from a source article or topic keyword, with internet search for hot news integration.

**Key Principles:**
1. **No fabrication** — All data must have verifiable sources
2. **No filler** — Remove "获取方式", "下期预告", empty predictions
3. **Human tone** — Write like developers talking to developers
4. **Source attribution** — Every claim needs a link or citation

## Workflow Overview

```
Phase 0: Input Parsing + Structure Selection
  │  Detect input type → extract topic/keywords
  │  Select article structure (A/B/C/D)
  │
  ├──────────────┬──────────────┐
  ▼              ▼              ▼
Agent A        Agent B        Agent C         Phase 1 (parallel)
Research       Hot News       Strategy
  │              │              │
  └──────────────┼──────────────┘
                 ▼
          Gate 1: Material Check + Source Validation
                 ▼
          Agent D: Writer                     Phase 2
                 ▼
          Agent E: Editor                     Phase 3
                 ▼
          Agent F: Fact Checker               Phase 4
                 ▼
          Gate 2: Final Check → Output + Supplement List
```

## Article Structure Templates (4 Types)

Structure is auto-selected based on topic type:

### Structure A: Direct (新闻/发布)

**Use when**: Product launch, company announcement, breaking news

```
What happened (1-2 sentences)
→ Key points (3 bullets max)
→ What it means for readers
→ Action items (if any)
→ Sources
```

**Characteristics**:
- No section numbers
- Natural transitions
- 500-800 characters
- Minimal Markdown (maybe 1-2 bold phrases)

**Example opening**:
```
OpenAI 在 3 月 5 日发布了 GPT-5.4。

更新就三点：降低幻觉率、减少说教、改进代码能力。
价格没变，订阅用户自动升级。
```

---

### Structure B: Question-Driven (评测/对比)

**Use when**: Product review, comparison, "should I upgrade" topics

```
A question to open ("GPT-5.4 值得升吗？")
→ My answer (clear stance)
→ Why (2-3 reasons with evidence)
→ Counter-argument
→ My response
→ Final recommendation
```

**Characteristics**:
- Conversational tone
- Back-and-forth reasoning
- 1000-1500 characters
- Occasional short paragraphs for emphasis

**Example opening**:
```
GPT-5.4 值得升吗？

我的答案：可以，但不用急。

如果你在用 GPT-5.3，变化感知不强。
如果你还在用 GPT-4，直接升。
```

---

### Structure C: Story-Driven (经验/案例)

**Use when**: Personal experience, case study, lesson learned

```
A scene to open ("今天早上...")
→ Problem encountered
→ How I solved it
→ What I learned
→ How readers can apply it
```

**Characteristics**:
- First-person narrative
- Has plot/tension
- 1200-1800 characters
- Emotional arc (frustration → solution → relief)

**Example opening**:
```
今天早上，我的自动化脚本挂了。

原因是 OpenAI 昨晚偷偷改了 API...
```

---

### Structure D: List-Based (工具/资源)

**Use when**: Tool recommendations, resource collections, checklists

```
One sentence on why this matters
→ 1. Tool 1 (why + how to use)
→ 2. Tool 2
→ 3. Tool 3
→ One sentence close
```

**Characteristics**:
- Practical, scannable
- Each item has clear value
- 800-1200 characters
- Numbers OK, but no fancy formatting

**Example opening**:
```
分享 3 个我每天都在用的 CLI 工具。

不是那种"应该有用"的，是真离不开的。
```

---

### Structure Selection Logic

| Topic Type | Keywords | Structure |
|------------|----------|-----------|
| News/Launch | "发布", "上线", "推出" | A (Direct) |
| Review/Comparison | "评测", "对比", "vs" | B (Question) |
| Experience/Case | "我", "经验", "案例" | C (Story) |
| Tools/Resources | "工具", "清单", "推荐" | D (List) |

Agent C (Strategy) proposes structure in Phase 1, Writer executes in Phase 2.

## Phase 0: Input Parsing

Detect input type and extract execution parameters:

| Input | Detection | Path |
|:---|:---|:---|
| Article URL | Contains `http` | Fetch → extract topic → Phase 1 |
| Article text | Long pasted content | Analyze directly → Phase 1 |
| Topic keyword | Short phrase | Skip fetch → keyword-driven Phase 1 |
| Mixed | URL + extra requirements | Fetch + parse requirements → Phase 1 |

Extract parameters (use defaults when unspecified):

```yaml
topic:      ""           # Core topic
keywords:   []           # Auto-expand synonyms
source_url: ""           # Source URL if any
tone:       "default"    # default / aggressive / neutral / humorous
word_count: 1500         # Target word count
hot_news:   true         # Search related trending news
output_dir: "./"         # Output directory
```

## Phase 1: Three Parallel Agents

Launch three agents concurrently. Read [references/agent-prompts.md](references/agent-prompts.md) for detailed prompt templates.

### Agent A: Research

Search for facts, data, expert opinions, and stakeholder responses around the topic. Use 5-layer search strategy from narrow to broad.

### Agent B: Hot News Search

Search trending news related to the topic using a 3-funnel approach:

1. **Direct hits (★★★)** — same event chain → must integrate into main narrative
2. **Same-field (★★☆)** — forms contrast or backdrop → 1-2 sentences
3. **Cross-field resonance (★☆☆)** — shared underlying logic → analogy only
4. **Unrelated (☆☆☆)** — discard, never force-fit

Also capture: mainstream opinion, dissent, controversy focal points.

### Agent C: Content Strategy

Analyze source (if any), propose differentiated angles from 7 dimensions: technical reality, business logic, strategic timing, user experience gap, historical parallel, contrarian view, China-local perspective.

Output: fact checklist, 5-7 angles, recommended structure, tone calibration, 3-4 punchlines.

## Gate 1: Material Sufficiency

Check before proceeding to writing:

```
□ ≥3 reliable data points?
□ ≥1 direct-hit hot news (★★★)?
□ ≥2 different stakeholder perspectives?
□ ≥3 viable differentiated angles?
□ ≥1 usable historical analogy?

5/5 → proceed | 3-4/5 → proceed with gaps noted | <3/5 → supplementary search
```

## Phase 2: Writing

Integrate all Phase 1 outputs into a draft. Read [references/formatting.md](references/formatting.md) for color system and HTML templates.

### Material Allocation Rules

- ★★★ hot news → weave into main argument
- ★★☆ hot news → 1-2 sentence supplement, don't steal the spotlight
- Key data → place after claims that need backing
- Direct quotes → place where authority matters
- Analogies → place where comprehension barriers exist

### Hot News Integration Modes

| Mode | When | How |
|:---|:---|:---|
| **Backdrop** | Hot news precedes topic | Open with hot news, transition to topic |
| **Contrast** | Hot news opposes topic | Side-by-side, let reader judge |
| **Analogy** | Shared underlying logic | 1-2 sentences in analysis section |
| **Evidence** | Hot news data supports claim | Embed as proof within argument |

### Quality Standards

Read the following reference documents:
- [references/quality-standards.md](references/quality-standards.md) — Writing standards and anti-patterns
- [references/calibration-checklist.md](references/calibration-checklist.md) — **Mandatory pre-output checklist**
- [references/formatting.md](references/formatting.md) — Color system and HTML templates

Core rules:

1. **Concise** — every sentence must carry information
2. **Opinionated** — ≥2 original angles not in the source
3. **Plain but assertive** — no "震惊/炸了/细思极恐"
4. **Respect reader intelligence** — facts + analysis, let them conclude
5. **Data needs denominators** — absolute numbers require base/ratio
6. **No emoji spam, no cliché closings**
7. **NO FABRICATION** — if you didn't test it, don't claim test results
8. **Source everything** — every data point needs a link or citation

## Phase 3: Editorial Review

Launch review agent to audit on 8 dimensions: plagiarism risk, information density, logic flow, language quality, fresh angles, hot news integration, mobile formatting, title strength.

Output: per-issue diagnosis + rewrite suggestion + 2-3 alternative titles.

## Phase 4: Fact Checking (NEW)

**Critical step** — Launch fact-checking agent to verify:

### Source Verification
```
□ Every data point has a source link?
□ Every quote is attributed to a real person/source?
□ No fabricated test results or case studies?
□ No "according to research" without citation?
```

### Content Integrity
```
□ No "获取方式", "下期预告" or similar operational filler?
□ No empty predictions ("必将", "一定会", "注定")?
□ No AI clichés ("震惊", "炸了", "细思极恐", "历史拐点")?
□ No forced engagement ("你觉得呢？评论区留言")?
```

### Uncertainty Handling
```
□ Unverified claims marked as "待验证" or "据称"?
□ Conflicting data presented with both sources?
□ Limitations acknowledged where applicable?
```

Output: fact-check report with issues flagged + required fixes.

## Phase 5: Final Output

1. Apply all editorial + fact-check fixes
2. Run final checklist:
   - [ ] All data sourced?
   - [ ] No fabricated content?
   - [ ] No operational filler?
   - [ ] Structure matches topic type?
   - [ ] Markdown used appropriately (not over-formatted)?
   - [ ] Title optimized?
   - [ ] Ending strong (no empty predictions)?
   - [ ] Word count in range?
3. Write Markdown file to output directory
4. **Also output**:
   - Source bibliography (all links used)
   - **Supplement List** (待补充清单) — items for user to add personal touch

## Supplement List Format (待补充清单)

After the article draft, output a supplement list with 2-4 items:

```markdown
───────────────────────────────
📝 建议补充的内容（可选）

1. 个人体验（位置：第 X 节）
   这里可以加你的实际使用感受
   提示：[具体问题引导，如"你这周用 GPT-5.4 做了什么？"]

2. 观点表态（位置：第 X 节）
   这里可以加你的明确立场
   提示：[如"你推荐升还是不推荐？为什么？"]

3. 个人案例（位置：可选）
   有没有真实用户故事可以加？
   提示：[如"有没有读者反馈可以分享？"]

───────────────────────────────
```

**Purpose**: Let user add personal experience and opinions to reduce AI-generated feel.
**Default**: 2-4 items, each with specific location and prompt question.

## Keyword Expansion Strategy

Auto-expand from user's topic:

```
Topic: "[用户主题]"
├── Core terms (CN + EN)
├── Event terms (related incidents)
├── Company/person terms
├── Concept terms (underlying ideas)
├── Comparison terms (X vs Y)
├── Industry terms
└── China-local terms (国内产品/平台)
```

Search in both English (primary sources) and Chinese (local perspectives), cross-validate.

## Quick Start Prompts

### Mode A: Rewrite from URL

```
使用多智能体工作流为我完成以下任务：

原文链接：[URL]

任务：
1. 抓取并分析原文，提炼核心信息
2. 联网搜索相关热点新闻和补充素材
3. 二次加工改写，增加新的论点和视角
4. 多轮打磨后输出微信公众号推文

写作标准：
- 简洁有力，有观点有干货
- 语言平实但有态度，不煽情
- 不把读者当小白，逻辑清晰节奏明快
- 尊重读者智商

重要要求：
- 所有数据必须有来源链接
- 不编造测试数据或案例
- 不添加"获取方式"、"下期预告"等运营内容
- 不确定内容标注"待验证"

排版要求：对比内容用不同颜色 section 标签区分，
避免抄袭，总字数 1200-1500 字，输出 Markdown 到当前目录。
```

### Mode B: Generate from topic keyword

```
使用多智能体工作流为我完成以下任务：

话题：[关键词或一句话描述]

任务：
1. 联网搜索该话题最新动态、核心事件、各方观点
2. 搜索关联热点新闻，找到可以"借势"的内容
3. 整合素材，生成一篇有观点的微信公众号推文

写作标准：
- 简洁有力，有观点有干货
- 语言平实但有态度，不煽情
- 不把读者当小白，逻辑清晰节奏明快
- 尊重读者智商

重要要求：
- 所有数据必须有来源链接
- 不编造测试数据或案例
- 不添加"获取方式"、"下期预告"等运营内容
- 不确定内容标注"待验证"

排版要求：对比内容用不同颜色 section 标签区分，
总字数 1200-1500 字，输出 Markdown 到当前目录。
```

## Scene Adaptation

| Scenario | Adjustment |
|:---|:---|
| Source is short/thin | Increase Research + Hot News agent weight |
| Source is long/dense | Increase Strategy agent weight, focus on filtering |
| Topic-only (no source) | All Phase 1 agents driven by keyword search |
| Stronger opinions | Add "provide 3 controversial takes" to Strategy |
| More neutral | Add "present multiple viewpoints without judgment" |
| Ride trending wave | Max Hot News agent, use Backdrop or Contrast mode |
| Non-tech topic | Adjust search dimensions (finance→policy; social→legal) |
| Article series | Add "reserve 2-3 extension angles for follow-ups" |
| Breaking news | Limit Hot News search to 24-48 hours |
| Long-form deep dive | Target 2500-3000 words, expand to 7-8 sections |

## Troubleshooting

| Problem | Solution |
|:---|:---|
| URL unreachable | Ask user to paste text, or search article title |
| Few search results | Broaden keywords, switch to English search |
| Weak hot news relevance | Downgrade to ★☆☆, analogy-only use |
| Missing stakeholder response | Note "no public statement as of search time" |
| Conflicting data | Show both sources with discrepancy noted |
| Major editorial issues | Don't patch — rewrite affected section from Phase 2 |
