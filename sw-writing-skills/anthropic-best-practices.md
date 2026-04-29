# Skill 编写最佳实践

> 学习如何编写有效的 Skill，让 Agent 能够发现并成功使用。

好的 Skill 是简洁、结构良好且经过实际使用测试的。本文提供实用的编写决策，帮助你编写 Agent 能够有效发现和使用的 Skill。

## 核心原则

### 简洁是关键

上下文窗口是公共资源。你的 Skill 与 Agent 需要知道的所有其他内容共享上下文窗口，包括：

- 系统提示
- 对话历史
- 其他 Skill 的元数据
- 用户的实际请求

并非 Skill 中的每个 token 都有即时成本。启动时，只有所有 Skill 的元数据（名称和描述）被预加载。Agent 仅在 Skill 变得相关时才会读取 SKILL.md，并且仅在需要时读取额外文件。然而，SKILL.md 中的简洁仍然重要：一旦 Agent 加载了它，每个 token 都会与对话历史和其他上下文竞争。

**默认假设**：Agent 已经很聪明

只添加 Agent 尚未具备的上下文。挑战每条信息：

- "Agent 真的需要这个解释吗？"
- "我能假设 Agent 已经知道这一点吗？"
- "这段文字 justify 它的 token 成本吗？"

**好示例：简洁**（约 50 个 token）：

```markdown
## 提取 PDF 文本

使用 pdfplumber 提取文本：

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**坏示例：太冗长**（约 150 个 token）：

```markdown
## 提取 PDF 文本

PDF（Portable Document Format）文件是一种常见的文件格式，包含文本、图像和其他内容。要从 PDF 中提取文本，你需要使用一个库。有许多可用于 PDF 处理的库，但我们推荐 pdfplumber，因为它易于使用且能处理大多数情况。首先，你需要使用 pip 安装它。然后你可以使用下面的代码...
```

简洁版本假设 Agent 知道什么是 PDF 以及库如何工作。

### 设置适当的自由度

将具体程度与任务的脆弱性和可变性相匹配。

**高自由度**（基于文本的指令）：

用于：

- 多种方法都有效
- 决策取决于上下文
- 启发式方法指导方法

示例：

```markdown
## 代码审查流程

1. 分析代码结构和组织
2. 检查潜在 bug 或边界情况
3. 建议可读性和可维护性改进
4. 验证是否符合项目约定
```

**中等自由度**（带参数的伪代码或脚本）：

用于：

- 存在首选模式
- 一些变化是可以接受的
- 配置影响行为

示例：

```markdown
## 生成报告

使用此模板并根据需要自定义：

```python
def generate_report(data, format="markdown", include_charts=True):
    # 处理数据
    # 生成指定格式的输出
    # 可选地包含可视化
```
```

**低自由度**（特定脚本，很少或没有参数）：

用于：

- 操作脆弱且容易出错
- 一致性至关重要
- 必须遵循特定序列

示例：

```markdown
## 数据库迁移

精确运行此脚本：

```bash
python scripts/migrate.py --verify --backup
```

不要修改命令或添加额外参数。
```

**类比**：将 Agent 想象成探索路径的机器人：

- **两侧都是悬崖的窄桥**：只有一条安全的前进道路。提供特定的护栏和精确指令（低自由度）。示例：必须按精确序列运行的数据库迁移。
- **没有危险的开放田野**：许多路径通向成功。给出一般方向，信任 Agent 找到最佳路线（高自由度）。示例：代码审查，其中上下文决定最佳方法。

### 用你计划使用的所有模型测试

Skill 作为模型的补充，因此有效性取决于底层模型。用你计划使用的所有模型测试你的 Skill。

**按模型的测试考虑**：

- **轻量模型**（快速、经济）：Skill 是否提供了足够的指导？
- **标准模型**（平衡）：Skill 是否清晰高效？
- **强推理模型**（强大推理）：Skill 是否避免了过度解释？

对强推理模型有效的东西可能需要为轻量模型提供更多细节。如果你计划在多个模型中使用你的 Skill，目标是适用于所有模型的指令。

## Skill 结构

**YAML Frontmatter**：SKILL.md frontmatter 需要两个字段：

- `name` - Skill 的人类可读名称（最多 64 个字符）
- `description` - Skill 功能和使用时机的一行描述（最多 1024 个字符）

### 命名规范

使用一致的命名模式，使 Skill 更容易引用和讨论。我们推荐对 Skill 名称使用**动名词形式**（动词 + -ing），因为这清楚地描述了 Skill 提供的活动或能力。

**好的命名示例（动名词形式）**：

- "Processing PDFs"
- "Analyzing spreadsheets"
- "Managing databases"
- "Testing code"
- "Writing documentation"

**可接受的替代方案**：

- 名词短语："PDF Processing", "Spreadsheet Analysis"
- 动作导向："Process PDFs", "Analyze Spreadsheets"

**避免**：

- 模糊名称："Helper", "Utils", "Tools"
- 过于通用："Documents", "Data", "Files"
- 在你的 Skill 集合中使用不一致的模式

一致的命名使以下操作更容易：

- 在文档和对话中引用 Skill
- 一目了然地了解 Skill 的功能
- 组织和搜索多个 Skill
- 维护专业、一致的 Skill 库

### 编写有效的描述

`description` 字段启用 Skill 发现，应包含 Skill 的功能和使用时机。

**始终使用第三人称**。描述被注入系统提示中，不一致的观点会导致发现问题。

- **好：** "Processes Excel files and generates reports"
- **避免：** "I can help you process Excel files"
- **避免：** "You can use this to process Excel files"

**具体并包含关键词**。包含 Skill 的功能以及使用它的特定触发器/上下文。

每个 Skill 只有一个描述字段。描述对 Skill 选择至关重要：Agent 使用它从可能 100+ 个可用 Skill 中选择正确的 Skill。你的描述必须提供足够的细节让 Agent 知道何时选择此 Skill，而 SKILL.md 的其余部分提供实现细节。

有效示例：

**PDF 处理 Skill：**

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Excel 分析 Skill：**

```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

**Git 提交助手 Skill：**

```yaml
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

避免模糊描述：

```yaml
description: Helps with documents
```

```yaml
description: Processes data
```

```yaml
description: Does stuff with files
```

### 渐进披露模式

SKILL.md 作为概述，根据需要指向详细材料，就像入职指南中的目录。Skill 目录结构可能如下所示：

```
pdf/
├── SKILL.md              # 主指令（需要时加载）
├── FORMS.md              # 表单填写指南（需要时加载）
├── reference.md          # API 参考（需要时加载）
├── examples.md           # 使用示例（需要时加载）
└── scripts/
    ├── analyze_form.py   # 实用脚本（执行，非加载）
    ├── fill_form.py      # 表单填写脚本
    └── validate.py       # 验证脚本
```

**实用指导：**

- 为获得最佳性能，保持 SKILL.md 主体在 600 行以下
- 当接近此限制时，将内容拆分为单独的文件
- 使用以下模式有效组织指令、代码和资源

#### 模式 1：带参考的高级指南

```markdown
---
name: PDF Processing
description: Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick start

Extract text with pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Advanced features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
**Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
```

Agent 仅在需要时加载 FORMS.md、REFERENCE.md 或 EXAMPLES.md。

#### 模式 2：按领域组织

对于具有多个领域的 Skill，按领域组织内容以避免加载不相关的上下文。

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

```markdown
# BigQuery Data Analysis

## Available datasets

**Finance**: Revenue, ARR, billing → See [reference/finance.md](reference/finance.md)
**Sales**: Opportunities, pipeline, accounts → See [reference/sales.md](reference/sales.md)
**Product**: API usage, features, adoption → See [reference/product.md](reference/product.md)
**Marketing**: Campaigns, attribution, email → See [reference/marketing.md](reference/marketing.md)

## Quick search

Find specific metrics using grep:

```bash
grep -i "revenue" reference/finance.md
grep -i "pipeline" reference/sales.md
grep -i "api usage" reference/product.md
```
```

#### 模式 3：条件详情

显示基本内容，链接到高级内容：

```markdown
# DOCX Processing

## Creating documents

Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents

For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

Agent 仅在用户需要这些功能时才会读取 REDLINING.md 或 OOXML.md。

### 避免深层嵌套引用

Agent 在从其他引用文件引用时可能会部分读取文件。遇到嵌套引用时，Agent 可能会使用 `head -100` 等命令预览内容，而不是读取整个文件，导致信息不完整。

**保持引用从 SKILL.md 只有一层深**。所有参考文件应直接从 SKILL.md 链接，以确保 Agent 在需要时读取完整文件。

**坏示例：太深**：

```markdown
# SKILL.md
See [advanced.md](advanced.md)...

# advanced.md
See [details.md](details.md)...

# details.md
Here's the actual information...
```

**好示例：一层深**：

```markdown
# SKILL.md

**Basic usage**: [instructions in SKILL.md]
**Advanced features**: See [advanced.md](advanced.md)
**API reference**: See [reference.md](reference.md)
**Examples**: See [examples.md](examples.md)
```

### 为较长的参考文件构建目录结构

对于超过 100 行的参考文件，在顶部包含目录。这确保 Agent 即使在使用部分读取预览时也能看到可用信息的完整范围。

**示例**：

```markdown
# API Reference

## Contents
- Authentication and setup
- Core methods (create, read, update, delete)
- Advanced features (batch operations, webhooks)
- Error handling patterns
- Code examples

## Authentication and setup
...

## Core methods
...
```

Agent 然后可以读取完整文件或根据需要跳转到特定部分。

## 工作流与反馈循环

### 对复杂任务使用工作流

将复杂操作分解为清晰、顺序的步骤。对于特别复杂的工作流，提供 Agent 可以复制到其响应中并随着进展勾选的检查清单。

**示例 1：研究综合工作流**（用于无代码的 Skill）：

```markdown
## Research synthesis workflow

Copy this checklist and track your progress:

```
Research Progress:
- [ ] Step 1: Read all source documents
- [ ] Step 2: Identify key themes
- [ ] Step 3: Cross-reference claims
- [ ] Step 4: Create structured summary
- [ ] Step 5: Verify citations
```

**Step 1: Read all source documents**

Review each document in the `sources/` directory. Note the main arguments and supporting evidence.

**Step 2: Identify key themes**

Look for patterns across sources. What themes appear repeatedly? Where do sources agree or disagree?

**Step 3: Cross-reference claims**

For each major claim, verify it appears in the source material. Note which source supports each point.

**Step 4: Create structured summary**

Organize findings by theme. Include:
- Main claim
- Supporting evidence from sources
- Conflicting viewpoints (if any)

**Step 5: Verify citations**

Check that every claim references the correct source document. If citations are incomplete, return to Step 3.
```

**示例 2：PDF 表单填写工作流**（用于有代码的 Skill）：

```markdown
## PDF form filling workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form (run analyze_form.py)
- [ ] Step 2: Create field mapping (edit fields.json)
- [ ] Step 3: Validate mapping (run validate_fields.py)
- [ ] Step 4: Fill the form (run fill_form.py)
- [ ] Step 5: Verify output (run verify_output.py)
```

**Step 1: Analyze the form**

Run: `python scripts/analyze_form.py input.pdf`

This extracts form fields and their locations, saving to `fields.json`.

**Step 2: Create field mapping**

Edit `fields.json` to add values for each field.

**Step 3: Validate mapping**

Run: `python scripts/validate_fields.py fields.json`

Fix any validation errors before continuing.

**Step 4: Fill the form**

Run: `python scripts/fill_form.py input.pdf fields.json output.pdf`

**Step 5: Verify output**

Run: `python scripts/verify_output.py output.pdf`

If verification fails, return to Step 2.
```

清晰的步骤防止 Agent 跳过关键验证。检查清单帮助 Agent 和你跟踪多步骤工作流的进度。

### 实现反馈循环

**常见模式**：运行验证器 → 修复错误 → 重复

此模式大大提高了输出质量。

**示例 1：风格指南合规**（用于无代码的 Skill）：

```markdown
## Content review process

1. Draft your content following the guidelines in STYLE_GUIDE.md
2. Review against the checklist:
   - Check terminology consistency
   - Verify examples follow the standard format
   - Confirm all required sections are present
3. If issues found:
   - Note each issue with specific section reference
   - Revise the content
   - Review the checklist again
4. Only proceed when all requirements are met
5. Finalize and save the document
```

**示例 2：文档编辑流程**（用于有代码的 Skill）：

```markdown
## Document editing process

1. Make your edits to `word/document.xml`
2. **Validate immediately**: `python ooxml/scripts/validate.py unpacked_dir/`
3. If validation fails:
   - Review the error message carefully
   - Fix the issues in the XML
   - Run validation again
4. **Only proceed when validation passes**
5. Rebuild: `python ooxml/scripts/pack.py unpacked_dir/ output.docx`
6. Test the output document
```

验证循环及早发现错误。

## 内容指南

### 避免时效性信息

不要包含会过时的信息：

**坏示例：时效性**（将变得错误）：

```markdown
If you're doing this before August 2025, use the old API.
After August 2025, use the new API.
```

**好示例**（使用 "old patterns" 部分）：

```markdown
## Current method

Use the v2 API endpoint: `api.example.com/v2/messages`

## Old patterns

<details>
<summary>Legacy v1 API (deprecated 2025-08)</summary>

The v1 API used: `api.example.com/v1/messages`

This endpoint is no longer supported.
</details>
```

旧模式部分提供历史上下文，而不会使主要内容变得杂乱。

### 使用一致的术语

选择一个术语并在整个 Skill 中一致使用：

**好 - 一致**：

- 始终使用 "API endpoint"
- 始终使用 "field"
- 始终使用 "extract"

**坏 - 不一致**：

- 混用 "API endpoint", "URL", "API route", "path"
- 混用 "field", "box", "element", "control"
- 混用 "extract", "pull", "get", "retrieve"

一致性帮助 Agent 理解和遵循指令。

## 常见模式

### 模板模式

为输出格式提供模板。将严格程度与你的需求相匹配。

**对于严格要求**（如 API 响应或数据格式）：

```markdown
## Report structure

ALWAYS use this exact template structure:

```markdown
# [Analysis Title]

## Executive summary
[One-paragraph overview of key findings]

## Key findings
- Finding 1 with supporting data
- Finding 2 with supporting data
- Finding 3 with supporting data

## Recommendations
1. Specific actionable recommendation
2. Specific actionable recommendation
```
```

**对于灵活指导**（当适应性有用时）：

```markdown
## Report structure

Here is a sensible default format, but use your best judgment based on the analysis:

```markdown
# [Analysis Title]

## Executive summary
[Overview]

## Key findings
[Adapt sections based on what you discover]

## Recommendations
[Tailor to the specific context]
```

Adjust sections as needed for the specific analysis type.
```

### 示例模式

对于输出质量取决于看到示例的 Skill，提供输入/输出对，就像常规提示一样：

```markdown
## Commit message format

Generate commit messages following these examples:

**Example 1:**
Input: Added user authentication with JWT tokens
Output:
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Example 2:**
Input: Fixed bug where dates displayed incorrectly in reports
Output:
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

**Example 3:**
Input: Updated dependencies and refactored error handling
Output:
```
chore: update dependencies and refactor error handling

- Upgrade lodash to 4.17.21
- Standardize error response format across endpoints
```

Follow this style: type(scope): brief description, then detailed explanation.
```

示例帮助 Agent 比单独描述更清楚地理解所需的风格和细节水平。

### 条件工作流模式

引导 Agent 通过决策点：

```markdown
## Document modification workflow

1. Determine the modification type:

   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below

2. Creation workflow:
   - Use docx-js library
   - Build document from scratch
   - Export to .docx format

3. Editing workflow:
   - Unpack existing document
   - Modify XML directly
   - Validate after each change
   - Repack when complete
```

如果工作流变得庞大或复杂，有许多步骤，请考虑将它们推入单独的文件，并告诉 Agent 根据手头的任务读取适当的文件。

## 评估与迭代

### 先构建评估

**在编写大量文档之前创建评估。** 这确保你的 Skill 解决真正的问题，而不是记录想象中的问题。

**评估驱动开发：**

1. **识别差距**：在没有 Skill 的情况下在代表性任务上运行 Agent。记录具体的失败或缺失的上下文
2. **创建评估**：构建三个测试这些差距的场景
3. **建立基线**：衡量没有 Skill 时 Agent 的表现
4. **编写最小指令**：创建刚好足够的内容来解决差距并通过评估
5. **迭代**：执行评估，与基线比较，并优化

此方法确保你解决实际问题，而不是预期可能永远不会实现的需求。

**评估结构**：

```json
{
  "skills": ["pdf-processing"],
  "query": "Extract all text from this PDF file and save it to output.txt",
  "files": ["test-files/document.pdf"],
  "expected_behavior": [
    "Successfully reads the PDF file using an appropriate PDF processing library or command-line tool",
    "Extracts text content from all pages in the document without missing any pages",
    "Saves the extracted text to a file named output.txt in a clear, readable format"
  ]
}
```

此示例展示了具有简单测试标准的数据驱动评估。用户可以创建自己的评估系统。评估是衡量 Skill 有效性的真理来源。

### 与 Agent 迭代开发 Skill

最有效的 Skill 开发过程涉及 Agent 本身。与一个 Agent 实例（"Agent A"）合作创建一个将由其他实例（"Agent B"）使用的 Skill。Agent A 帮助你设计和优化指令，而 Agent B 在实际任务中测试它们。这有效是因为 Agent 模型理解如何编写有效的 Agent 指令以及 Agent 需要什么信息。

**创建新 Skill：**

1. **在没有 Skill 的情况下完成任务**：使用正常提示与 Agent A 合作解决问题。在工作时，你会自然地提供上下文、解释偏好和分享程序知识。注意你反复提供什么信息。

2. **识别可复用模式**：完成任务后，确定你提供的哪些上下文对类似的未来任务有用。

   **示例**：如果你完成了 BigQuery 分析，你可能提供了表名、字段定义、过滤规则（如"始终排除测试账户"）和常见查询模式。

3. **让 Agent A 创建 Skill**："创建一个 Skill，捕捉我们刚刚使用的 BigQuery 分析模式。包括表结构、命名约定和关于过滤测试账户的规则。"

   Agent 模型原生理解 Skill 格式和结构。你不需要特殊的系统提示或"编写 Skill"的 Skill 来让 Agent 帮助创建 Skill。简单地要求 Agent 创建 Skill，它就会生成具有适当 frontmatter 和 body 内容的正确结构的 SKILL.md 内容。

4. **审查简洁性**：检查 Agent A 是否添加了不必要的解释。询问："删除关于 win rate 含义的解释——Agent 已经知道那个了。"

5. **改进信息架构**：要求 Agent A 更有效地组织内容。例如："将此组织，使表结构放在单独的参考文件中。我们以后可能会添加更多表。"

6. **在类似任务上测试**：使用 Agent B（加载了 Skill 的全新实例）在相关用例上进行测试。观察 Agent B 是否找到正确的信息、正确应用规则并成功处理任务。

7. **基于观察迭代**：如果 Agent B 遇到困难或遗漏了某些东西，带着具体信息返回 Agent A："当 Agent 使用此 Skill 时，它忘记了按 Q4 日期过滤。我们应该添加关于日期过滤模式的部分吗？"

**迭代现有 Skill：**

相同的分层模式在改进 Skill 时继续。你在以下之间交替：

- **与 Agent A 合作**（帮助优化 Skill 的专家）
- **与 Agent B 测试**（使用 Skill 执行实际工作的 Agent）
- **观察 Agent B 的行为**并将见解带回 Agent A

1. **在实际工作流中使用 Skill**：给 Agent B（加载了 Skill）实际任务，而不是测试场景

2. **观察 Agent B 的行为**：注意它在哪里遇到困难、成功或做出意外选择

   **示例观察**："当我要求 Agent B 提供区域销售报告时，它编写了查询但忘记了过滤测试账户，即使 Skill 提到了这个规则。"

3. **返回 Agent A 进行改进**：分享当前的 SKILL.md 并描述你观察到的内容。询问："我注意到 Agent B 在要求区域报告时忘记了过滤测试账户。Skill 提到了过滤，但也许它不够突出？"

4. **审查 Agent A 的建议**：Agent A 可能建议重新组织以使规则更突出，使用更强的语言如"MUST filter"而不是"always filter"，或重构工作流部分。

5. **应用和测试更改**：使用 Agent A 的优化更新 Skill，然后在类似请求上再次与 Agent B 测试

6. **基于使用重复**：当你遇到新场景时，继续此观察-优化-测试循环。每次迭代都基于真实的 Agent 行为而不是假设来改进 Skill。

**收集团队反馈：**

1. 与队友分享 Skill 并观察他们的使用
2. 询问：Skill 是否在预期时激活？指令是否清晰？缺少什么？
3. 纳入反馈以解决你自己使用模式中的盲点

**为什么此方法有效**：Agent A 理解 Agent 需求，你提供领域专业知识，Agent B 通过实际使用揭示差距，迭代优化基于观察到的行为而不是假设来改进 Skill。

### 观察 Agent 如何导航 Skill

在迭代 Skill 时，注意 Agent 在实践中实际如何使用它们。观察：

- **意外的探索路径**：Agent 是否以你未预料的顺序读取文件？这可能表明你的结构没有你想象的那么直观
- **遗漏的连接**：Agent 是否未能遵循对重要文件的引用？你的链接可能需要更明确或更突出
- **过度依赖某些部分**：如果 Agent 反复读取同一个文件，请考虑该内容是否应放在主 SKILL.md 中
- **被忽略的内容**：如果 Agent 从未访问捆绑文件，它可能是不必要的或在主指令中信号不佳

基于这些观察而不是假设进行迭代。Skill 元数据中的 `name` 和 `description` 特别关键。Agent 使用这些来决定是否对当前任务触发 Skill。确保它们清楚地描述 Skill 的功能以及何时应使用它。

## 反模式

### 避免 Windows 风格路径

始终在文件路径中使用正斜杠，即使在 Windows 上：

- ✅ **好**：`scripts/helper.py`, `reference/guide.md`
- ❌ **避免**：`scripts\helper.py`, `reference\guide.md`

Unix 风格路径适用于所有平台，而 Windows 风格路径在 Unix 系统上会导致错误。

### 避免提供过多选项

除非必要，否则不要呈现多种方法：

```markdown
**Bad example: Too many choices** (confusing):
"You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image, or..."

**Good example: Provide a default** (with escape hatch):
"Use pdfplumber for text extraction:
```python
import pdfplumber
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead."
```

## 高级：带可执行代码的 Skill

以下部分侧重于包含可执行脚本的 Skill。如果你的 Skill 仅使用 Markdown 指令，请跳过此部分。

### 解决，不要推卸

为 Skill 编写脚本时，处理错误条件而不是推卸给 Agent。

**好示例：显式处理错误**：

```python
def process_file(path):
    """Process a file, creating it if it doesn't exist."""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # Create file with default content instead of failing
        print(f"File {path} not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # Provide alternative instead of failing
        print(f"Cannot access {path}, using default")
        return ''
```

**坏示例：推卸给 Agent**：

```python
def process_file(path):
    # Just fail and let the agent figure it out
    return open(path).read()
```

配置参数也应得到证实和记录，以避免"巫毒常量"（Ousterhout 定律）。如果你不知道正确的值，Agent 如何确定它？

**好示例：自文档化**：

```python
# HTTP requests typically complete within 30 seconds
# Longer timeout accounts for slow connections
REQUEST_TIMEOUT = 30

# Three retries balances reliability vs speed
# Most intermittent failures resolve by the second retry
MAX_RETRIES = 3
```

**坏示例：魔法数字**：

```python
TIMEOUT = 47  # Why 47?
RETRIES = 5   # Why 5?
```

### 提供实用脚本

即使 Agent 可以编写脚本，预制脚本也有优势：

**实用脚本的好处**：

- 比生成的代码更可靠
- 节省 token（无需在上下文中包含代码）
- 节省时间（无需代码生成）
- 确保跨使用的一致性

指令文件引用脚本，Agent 可以执行它而无需将其完整内容加载到上下文中。

**重要区别**：在你的指令中明确 Agent 应该：

- **执行脚本**（最常见）："Run `analyze_form.py` to extract fields"
- **将其作为参考读取**（用于复杂逻辑）："See `analyze_form.py` for the field extraction algorithm"

对于大多数实用脚本，执行是首选，因为它更可靠和高效。

**示例**：

```markdown
## Utility scripts

**analyze_form.py**: Extract all form fields from PDF

```bash
python scripts/analyze_form.py input.pdf > fields.json
```

Output format:
```json
{
  "field_name": {"type": "text", "x": 100, "y": 200},
  "signature": {"type": "sig", "x": 150, "y": 500}
}
```

**validate_boxes.py**: Check for overlapping bounding boxes

```bash
python scripts/validate_boxes.py fields.json
# Returns: "OK" or lists conflicts
```

**fill_form.py**: Apply field values to PDF

```bash
python scripts/fill_form.py input.pdf fields.json output.pdf
```
```

### 使用视觉分析

当输入可以渲染为图像时，让 Agent 分析它们：

```markdown
## Form layout analysis

1. Convert PDF to images:
   ```bash
   python scripts/pdf_to_images.py form.pdf
   ```

2. Analyze each page image to identify form fields
3. Agent can see field locations and types visually
```

Agent 的视觉能力帮助理解布局和结构。

### 创建可验证的中间输出

当 Agent 执行复杂的开放式任务时，它可能会犯错误。"计划-验证-执行"模式通过让 Agent 首先在结构化格式中创建计划，然后使用脚本验证该计划再执行它来及早发现错误。

**示例**：想象要求 Agent 基于电子表格更新 PDF 中的 50 个表单字段。没有验证，Agent 可能会引用不存在的字段、创建冲突的值、遗漏必填字段或错误地应用更新。

**解决方案**：使用上面显示的工作流模式，但添加一个中间 `changes.json` 文件，在应用更改之前得到验证。工作流变为：分析 → **创建计划文件** → **验证计划** → 执行 → 验证。

**为什么此模式有效：**

- **及早发现错误**：验证在应用更改之前发现问题
- **机器可验证**：脚本提供客观验证
- **可逆的计划**：Agent 可以迭代计划而不接触原件
- **清晰的调试**：错误消息指向具体问题

**何时使用**：批处理操作、破坏性更改、复杂验证规则、高风险操作。

**实现提示**：使验证脚本具有详细的特定错误消息，如 "Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed"，以帮助 Agent 修复问题。

### 包依赖

Skill 在具有平台特定限制的代码执行环境中运行：

- **Web 平台**：可以从 npm 和 PyPI 安装包并从 GitHub 仓库拉取
- **API 平台**：没有网络访问权限，也没有运行时包安装

在 SKILL.md 中列出必需的包，并验证它们在代码执行环境中可用。

### 运行时环境

Skill 在具有文件系统访问权限、bash 命令和代码执行能力的代码执行环境中运行。

**这如何影响你的编写：**

**Agent 如何访问 Skill：**

1. **元数据预加载**：启动时，所有 Skill 的 YAML frontmatter 中的名称和描述被加载到系统提示中
2. **文件按需读取**：Agent 使用 bash Read 工具在需要时从文件系统访问 SKILL.md 和其他文件
3. **脚本高效执行**：实用脚本可以通过 bash 执行，而无需将其完整内容加载到上下文中。只有脚本的输出消耗 token
4. **大文件无上下文惩罚**：参考文件、数据或文档在实际读取之前不消耗上下文 token

- **文件路径很重要**：Agent 像文件系统一样导航你的 Skill 目录。使用正斜杠（`reference/guide.md`），而不是反斜杠
- **描述性地命名文件**：使用指示内容的名称：`form_validation_rules.md`，而不是 `doc2.md`
- **按领域或功能组织目录**
  - 好：`reference/finance.md`, `reference/sales.md`
  - 坏：`docs/file1.md`, `docs/file2.md`
- **捆绑全面的资源**：包含完整的 API 文档、广泛的示例、大型数据集；在访问之前没有上下文惩罚
- **对确定性操作优先使用脚本**：编写 `validate_form.py` 而不是要求 Agent 生成验证代码
- **明确执行意图**：
  - "Run `analyze_form.py` to extract fields"（执行）
  - "See `analyze_form.py` for the extraction algorithm"（作为参考读取）
- **测试文件访问模式**：通过使用真实请求测试，验证 Agent 可以导航你的目录结构

**示例：**

```
bigquery-skill/
├── SKILL.md (overview, points to reference files)
└── reference/
    ├── finance.md (revenue metrics)
    ├── sales.md (pipeline data)
    └── product.md (usage analytics)
```

当用户询问收入时，Agent 读取 SKILL.md，看到对 `reference/finance.md` 的引用，并调用 bash 仅读取该文件。sales.md 和 product.md 文件保留在文件系统上，在需要之前消耗零上下文 token。这种基于文件系统的模型是实现渐进式披露的原因。Agent 可以导航并选择性加载每个任务所需的确切内容。

### 避免假设工具已安装

不要假设包可用：

```markdown
**Bad example: Assumes installation**:
"Use the pdf library to process the file."

**Good example: Explicit about dependencies**:
"Install required package: `pip install pypdf`

Then use it:
```python
from pypdf import PdfReader
reader = PdfReader("file.pdf")
```"
```

## 技术注意事项

### YAML frontmatter 要求

SKILL.md frontmatter 需要 `name`（最多 64 个字符）和 `description`（最多 1024 个字符）字段。

### Token 预算

为获得最佳性能，保持 SKILL.md 主体在 600 行以下。如果你的内容超过此限制，使用前面描述的渐进披露模式将其拆分为单独的文件。

## 有效 Skill 检查清单

在分享 Skill 之前，验证：

### 核心质量

- [ ] 描述具体并包含关键词
- [ ] 描述包含 Skill 的功能和使用时机
- [ ] SKILL.md 主体在 600 行以下
- [ ] 额外细节在单独文件中（如需要）
- [ ] 无时效性信息（或在"旧模式"部分中）
- [ ] 整个 Skill 术语一致
- [ ] 示例具体，不是抽象的
- [ ] 文件引用只有一层深
- [ ] 渐进披露使用得当
- [ ] 工作流有清晰的步骤

### 代码和脚本

- [ ] 脚本解决问题而不是推卸给 Agent
- [ ] 错误处理显式且有帮助
- [ ] 没有"巫毒常量"（所有值都有依据）
- [ ] 所需包在指令中列出并验证为可用
- [ ] 脚本有清晰的文档
- [ ] 没有 Windows 风格路径（全部正斜杠）
- [ ] 关键操作有验证/验证步骤
- [ ] 质量关键任务包含反馈循环

### 测试

- [ ] 至少创建了三个评估
- [ ] 用轻量、标准和强推理模型测试
- [ ] 用真实使用场景测试
- [ ] 纳入了团队反馈（如适用）
