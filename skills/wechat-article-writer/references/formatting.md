# WeChat Formatting Guide

Color system, HTML templates, and formatting rules for WeChat public account articles.

---

## Color System

| Color | Border | Background | Use for |
|:---|:---|:---|:---|
| Blue | `#1890ff` | `#f0f7ff` | Neutral info / timelines / background |
| Green | `#52c41a` | `#f6ffed` | Positive / recommended / advantage |
| Red | `#ff4d4f` | `#fff1f0` | Risk / warning / disadvantage |
| Orange | `#fa8c16` | `#fff7e6` | Notable / controversial / caution |
| Purple | `#722ed1` | `#f9f0ff` | Deep insight / prediction / opinion |

## HTML Template

```html
<section style="background:[BG_COLOR]; padding:12px 16px; border-left:4px solid [BORDER_COLOR]; border-radius:4px; margin:16px 0;">
Content here
</section>
```

### Quick copy examples

**Blue (neutral/timeline):**
```html
<section style="background:#f0f7ff; padding:12px 16px; border-left:4px solid #1890ff; border-radius:4px; margin:16px 0;">
</section>
```

**Green (positive):**
```html
<section style="background:#f6ffed; padding:12px 16px; border-left:4px solid #52c41a; border-radius:4px; margin:16px 0;">
</section>
```

**Red (risk/warning):**
```html
<section style="background:#fff1f0; padding:12px 16px; border-left:4px solid #ff4d4f; border-radius:4px; margin:16px 0;">
</section>
```

**Orange (notable/controversial):**
```html
<section style="background:#fff7e6; padding:12px 16px; border-left:4px solid #fa8c16; border-radius:4px; margin:16px 0;">
</section>
```

**Purple (deep insight):**
```html
<section style="background:#f9f0ff; padding:12px 16px; border-left:4px solid #722ed1; border-radius:4px; margin:16px 0;">
</section>
```

## Formatting Rules

- **Tables:** Max 3 columns. Prefer bullet lists over tables for WeChat compatibility.
- **Horizontal rules:** Only between major sections. Don't over-fragment.
- **Bold:** Max 1-2 per paragraph. Mark core judgments only.
- **Blockquote `>`:** Use for opening summary or single-line punchlines.
- **Inline code backticks:** Use for product names, technical terms.
- **No emoji** unless explicitly requested.
- **Line breaks:** Keep paragraphs short (2-4 sentences max) for mobile readability.
- **Section numbering:** Use 一、二、三 or 01、02、03 style, not nested numbering.
