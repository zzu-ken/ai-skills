# Writing Quality Standards v2

Standards, anti-patterns, review dimensions, and troubleshooting for WeChat article writing.

---

## Must-Do Checklist

| # | Standard | Test |
|:---:|:---|:---|
| 1 | Concise, no filler | Remove the sentence — does the article lose information? If not, delete it. |
| 2 | Opinionated with substance | ≥2 original angles not present in source material |
| 3 | Plain but assertive | No "震惊/炸了/细思极恐", but clear judgments are made |
| 4 | No pandering | No emoji spam, no explaining common knowledge |
| 5 | Logical, fast-paced | Paragraphs connected by cause-effect or progression; short sentences dominate |
| 6 | Respect reader intelligence | Present facts + analysis; let reader draw conclusions |
| 7 | Data needs denominators | Absolute numbers must include base or ratio for context |
| 8 | **Source everything** | Every data point has a link or citation |
| 9 | **No fabrication** | No unverified test results, case studies, or quotes |

## Must-Avoid List (Updated)

### Content Integrity Violations (CRITICAL)
- ❌ Fabricated test data ("我测试了 30 个任务" — 实际没测)
- ❌ Fake percentages ("幻觉率降 26.8%" — 无来源)
- ❌ Made-up quotes ("XX 专家表示" — 查无此人)
- ❌ "According to research" without citation
- ❌ Fake case studies ("我的一个朋友..." — 编的)

### Operational Filler (Remove from article content)
- ❌ "关注我的公众号，回复 XXX 获取"
- ❌ "下期预告：《XXX》"
- ❌ "觉得有用就点个在看吧"
- ❌ "评论区聊聊你的看法"

### AI Clichés
- ❌ "今天，XX 圈炸了！"
- ❌ "细思极恐" / "历史拐点" / "数字灵魂"
- ❌ "必将" / "一定会" / "注定" (empty predictions)
- ❌ "最后说两句" (套路化结尾)
- ❌ "你觉得呢？" (forced engagement)

### Structure Rigidity (NEW — Reduce AI Feel)
- ❌ Fixed structure every time (一、二、三、四、五)
- ❌ Every section has a subheading
- ❌ Tables in every article (especially comparison tables)
- ❌ Code blocks when not needed
- ❌ "来源" section when only 1-2 sources
- ❌ Paragraphs all same length
- ❌ No emotional variation

### Markdown Overuse (NEW)
- ❌ Using `##` for every section
- ❌ Tables when bullet lists work better
- ❌ Code blocks for single-line commands
- ❌ Bold text in every paragraph
- ❌ Horizontal rules between every section

**Guideline**: Markdown should serve content, not dictate structure. Some articles need no headings at all.

## Must-Avoid List

- "今天，XX圈炸了！"
- "细思极恐" / "历史拐点" / "数字灵魂"
- Stacked parallel sentences (排比堆叠)
- Consecutive emoji decoration
- "你觉得呢？评论区留言！" style forced interaction
- Over-prediction: "必将" / "一定会" / "注定"
- Raw numbers without denominators ("70万退订" needs "9亿周活" context)
- Complex CSS (gradients, shadows) that break in WeChat renderer
- Tables wider than 3 columns on mobile

## Editorial Review Dimensions

| Dimension | Check | Fail Criteria |
|:---|:---|:---|
| Plagiarism risk | Any 15+ consecutive matching chars | Any single instance |
| Information density | Each sentence deletion test | >2 filler sentences |
| Logic flow | Paragraph-to-paragraph links | Any logical jump |
| Language quality | Cliché and filler scan | Contains banned phrases |
| Fresh angles | Count original perspectives | <2 unique angles |
| Hot news integration | Natural fit assessment | Forced or scene-stealing |
| Mobile formatting | Phone readability check | Wide tables or heavy HTML |
| Title strength | Info value + curiosity gap | Pure clickbait or too bland |
| **Source verification** | Every data point has link | Any unsourced claim |
| **Content integrity** | No fabricated tests/quotes | Any fabrication found |

## Common Problems

| Problem | Solution |
|:---|:---|
| Ending too weak | End with reader agency — their choice matters, not "未来会怎样" |
| Opening too slow | First sentence = what happened. No warm-up. |
| Opinions without evidence | Every judgment needs ≥1 data point or concrete example |
| Hot news forced in | Downgrade relevance rating; use only as analogy or drop entirely |
| Too similar to source | Restructure argument order, replace analogies, add angles source lacks |
| Tone inconsistent | Scan for sudden shifts between casual and formal; pick one register |
| **Fabricated data** | Remove or mark "待验证"; ask user to provide real test results |
| **Missing sources** | Add source links or rephrase as opinion ("我认为" vs "数据显示") |
| **Operational filler** | Remove "获取方式", "下期预告" — these are not article content |

---

## Fact-Checking Checklist (NEW)

Before an article is approved, verify:

### Source Verification
- [ ] Every statistic has a source link or citation?
- [ ] Every quote is attributed to a real, named person?
- [ ] "According to X" always names X with a link?
- [ ] No anonymous "专家表示" or "研究表明"?

### Content Integrity
- [ ] No fabricated test results ("我测试了 X 个...")?
- [ ] No fake case studies?
- [ ] No made-up percentages or numbers?
- [ ] If claiming personal experience, is it marked for user to verify?

### Uncertainty Handling
- [ ] Unverified claims marked as "据称" or "待验证"?
- [ ] Conflicting data presented with both sources?
- [ ] Limitations acknowledged where applicable?

### Operational Filler Removal
- [ ] No "关注公众号回复 XXX"?
- [ ] No "下期预告"?
- [ ] No forced engagement ("点个在看", "评论区留言")?

**If any check fails**: Return to writer with specific fixes required.
