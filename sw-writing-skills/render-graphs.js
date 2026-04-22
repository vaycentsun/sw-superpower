#!/usr/bin/env node

/**
 * 从技能的 SKILL.md 渲染 graphviz 图表为 SVG 文件。
 *
 * 用法:
 *   ./render-graphs.js <技能目录>           # 单独渲染每个图表
 *   ./render-graphs.js <技能目录> --combine # 合并所有为一个图表
 *
 * 从 SKILL.md 中提取所有 ```dot 代码块并渲染为 SVG。
 * 有助于帮助用户可视化流程。
 *
 * 需要: 系统上已安装 graphviz (dot)
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function extractDotBlocks(markdown) {
  const blocks = [];
  const regex = /```dot\n([\s\S]*?)```/g;
  let match;

  while ((match = regex.exec(markdown)) !== null) {
    const content = match[1].trim();

    // 提取 digraph 名称
    const nameMatch = content.match(/digraph\s+(\w+)/);
    const name = nameMatch ? nameMatch[1] : `graph_${blocks.length + 1}`;

    blocks.push({ name, content });
  }

  return blocks;
}

function extractGraphBody(dotContent) {
  // 从 digraph 中提取主体（节点和边）
  const match = dotContent.match(/digraph\s+\w+\s*\{([\s\S]*)\}/);
  if (!match) return '';

  let body = match[1];

  // 移除 rankdir（我们将在顶层设置一次）
  body = body.replace(/^\s*rankdir\s*=\s*\w+\s*;?\s*$/gm, '');

  return body.trim();
}

function combineGraphs(blocks, skillName) {
  const bodies = blocks.map((block, i) => {
    const body = extractGraphBody(block.content);
    // 将每个子图包装在集群中以进行视觉分组
    return `  subgraph cluster_${i} {
    label="${block.name}";
    ${body.split('\n').map(line => '  ' + line).join('\n')}
  }`;
  });

  return `digraph ${skillName}_combined {
  rankdir=TB;
  compound=true;
  newrank=true;

${bodies.join('\n\n')}
}`;
}

function renderToSvg(dotContent) {
  try {
    return execSync('dot -Tsvg', {
      input: dotContent,
      encoding: 'utf-8',
      maxBuffer: 10 * 1024 * 1024
    });
  } catch (err) {
    console.error('运行 dot 出错:', err.message);
    if (err.stderr) console.error(err.stderr.toString());
    return null;
  }
}

function main() {
  const args = process.argv.slice(2);
  const combine = args.includes('--combine');
  const skillDirArg = args.find(a => !a.startsWith('--'));

  if (!skillDirArg) {
    console.error('用法: render-graphs.js <技能目录> [--combine]');
    console.error('');
    console.error('选项:');
    console.error('  --combine    合并所有图表为一个 SVG');
    console.error('');
    console.error('示例:');
    console.error('  ./render-graphs.js ../subagent-driven-development');
    console.error('  ./render-graphs.js ../subagent-driven-development --combine');
    process.exit(1);
  }

  const skillDir = path.resolve(skillDirArg);
  const skillFile = path.join(skillDir, 'SKILL.md');
  const skillName = path.basename(skillDir).replace(/-/g, '_');

  if (!fs.existsSync(skillFile)) {
    console.error(`错误: ${skillFile} 未找到`);
    process.exit(1);
  }

  // 检查 dot 是否可用
  try {
    execSync('which dot', { encoding: 'utf-8' });
  } catch {
    console.error('错误: 未找到 graphviz (dot)。安装方法:');
    console.error('  brew install graphviz    # macOS');
    console.error('  apt install graphviz     # Linux');
    process.exit(1);
  }

  const markdown = fs.readFileSync(skillFile, 'utf-8');
  const blocks = extractDotBlocks(markdown);

  if (blocks.length === 0) {
    console.log('在', skillFile, '中未找到 ```dot 代码块');
    process.exit(0);
  }

  console.log(`在 ${path.basename(skillDir)}/SKILL.md 中找到 ${blocks.length} 个图表`);

  const outputDir = path.join(skillDir, 'diagrams');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir);
  }

  if (combine) {
    // 合并所有图表为一个
    const combined = combineGraphs(blocks, skillName);
    const svg = renderToSvg(combined);
    if (svg) {
      const outputPath = path.join(outputDir, `${skillName}_combined.svg`);
      fs.writeFileSync(outputPath, svg);
      console.log(`  已渲染: ${skillName}_combined.svg`);

      // 同时写入 dot 源文件用于调试
      const dotPath = path.join(outputDir, `${skillName}_combined.dot`);
      fs.writeFileSync(dotPath, combined);
      console.log(`  源文件: ${skillName}_combined.dot`);
    } else {
      console.error('  渲染合并图表失败');
    }
  } else {
    // 单独渲染每个
    for (const block of blocks) {
      const svg = renderToSvg(block.content);
      if (svg) {
        const outputPath = path.join(outputDir, `${block.name}.svg`);
        fs.writeFileSync(outputPath, svg);
        console.log(`  已渲染: ${block.name}.svg`);
      } else {
        console.error(`  失败: ${block.name}`);
      }
    }
  }

  console.log(`\n输出: ${outputDir}/`);
}

main();
