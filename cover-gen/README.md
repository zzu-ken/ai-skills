# 封面图自动化生成工具 (Cover Gen)

基于 Node.js + Puppeteer 的高性能封面生成方案，适用于公众号、小红书、视频封面等场景。

## 🌟 特点
- **设计感强**：基于 HTML/CSS 渲染，天生支持渐变、毛玻璃特效、Emoji 和完美排版。
- **自动化**：一行命令即可生成，支持自定义参数。
- **高性能**：调用本地 Chrome/Edge 浏览器，渲染精度高（默认 2x 高清采样）。

## 🚀 快速开始

### 1. 安装依赖 (如果尚未安装)
```bash
cd cover-gen
npm install
```

### 2. 生成一张封面
```bash
node index.js --text "我的第一个 AI 封面" --colors "#84fab0,#8fd3f4" --output "test.png"
```

## 📝 命令行参数手册

| 参数 | 必填 | 说明 | 示例 |
| :--- | :---: | :--- | :--- |
| `--text` | 是 | 主标题文字 | `--text "标题"` |
| `--subtext` | 否 | 副标题文字 | `--subtext "副标题"` |
| `--footer` | 否 | 底部品牌/作者名 | `--footer "@KEN"` |
| `--colors` | 否 | 渐变背景颜色 (支持多个，逗号分隔) | `--colors "#ff9a9e,#fecfef"` |
| `--gradient` | 否 | 完整的 CSS 渐变字符串 (优先级最高) | `--gradient "linear-gradient(45deg, red, blue)"` |
| `--direction` | 否 | 渐变方向 (默认 135deg) | `--direction "to bottom"` |
| `--dark` | 否 | 开启深色卡片模式 | `--dark` |
| `--width` | 否 | 图片宽度 (默认 1080) | `--width 1080` |
| `--height` | 否 | 图片高度 (默认 1440) | `--height 1920` |
| `--output` | 否 | 输出文件名 (默认 cover.png) | `--output "result.png"` |

## 💡 示例场景

### 生成小红书封面 (3:4, 默认)
```bash
node index.js --text "10个提升效率的工具" --subtext "干货分享 | 建议收藏" --colors "#f6d365, #fda085"
```

### 生成深色风格封面
```bash
node index.js --text "深夜编程指南" --colors "#243b55, #141e30" --dark
```

### 生成公众号首图 (16:9)
```bash
node index.js --text "科技周报" --width 900 --height 383 --colors "#a1c4fd, #c2e9fb"
```

## 🎨 自定义样式
如果需要修改字体大小、间距或增加 Logo，请直接编辑 `cover-gen/template.html` 文件。修改其中的 CSS 即可实现完全的视觉自定义。
