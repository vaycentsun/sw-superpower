/**
 * OpenCode.ai 的 Superpowers 插件
 *
 * 通过系统提示转换注入 sw-superpowers 引导上下文。
 * 通过配置钩子自动注册技能目录（无需 symlink）。
 */

import path from 'path';
import fs from 'fs';
import os from 'os';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// 简单 frontmatter 提取（引导阶段避免依赖 skills-core）
const extractAndStripFrontmatter = (content) => {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content };

  const frontmatterStr = match[1];
  const body = match[2];
  const frontmatter = {};

  for (const line of frontmatterStr.split('\n')) {
    const colonIdx = line.indexOf(':');
    if (colonIdx > 0) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim().replace(/^["']|["']$/g, '');
      frontmatter[key] = value;
    }
  }

  return { frontmatter, content: body };
};

// 规范化路径：去除空白，展开 ~，解析为绝对路径
const normalizePath = (p, homeDir) => {
  if (!p || typeof p !== 'string') return null;
  let normalized = p.trim();
  if (!normalized) return null;
  if (normalized.startsWith('~/')) {
    normalized = path.join(homeDir, normalized.slice(2));
  } else if (normalized === '~') {
    normalized = homeDir;
  }
  return path.resolve(normalized);
};

export const SwSuperpowersPlugin = async ({ client, directory }) => {
  const homeDir = os.homedir();
  // 注意：本地项目使用 sw- 前缀的目录而不是 skills/ 子目录
  const swSuperpowersSkillsDir = path.resolve(__dirname, '../..');
  const envConfigDir = normalizePath(process.env.OPENCODE_CONFIG_DIR, homeDir);
  const configDir = envConfigDir || path.join(homeDir, '.config/opencode');

  // 辅助函数：生成引导内容
  const getBootstrapContent = () => {
    // 尝试加载 using-superpowers 技能
    const skillPath = path.join(swSuperpowersSkillsDir, 'sw-using-superpowers', 'SKILL.md');
    if (!fs.existsSync(skillPath)) return null;

    const fullContent = fs.readFileSync(skillPath, 'utf8');
    const { content } = extractAndStripFrontmatter(fullContent);

    const toolMapping = `**OpenCode 工具映射：**
当技能引用你没有的工具时，替换为 OpenCode 等效项：
- \`TodoWrite\` → \`todowrite\`
- \`Task\` 工具带子 Agent → 使用 OpenCode 的子 Agent 系统
- \`Skill\` 工具 → OpenCode 原生 \`skill\` 工具
- \`Read\`、\`Write\`、\`Edit\`、\`Bash\` → 你的原生工具

使用 OpenCode 原生 \`skill\` 工具列出和加载技能。`;

    return `<EXTREMELY_IMPORTANT>
You have superpowers.

**IMPORTANT: The sw-using-superpowers skill content is included below. It is ALREADY LOADED - you are currently following it. Do NOT use the skill tool to load "sw-using-superpowers" again - that would be redundant.**

${content}

${toolMapping}
</EXTREMELY_IMPORTANT>`;
  };

  return {
    // 将技能路径注入实时配置，使 OpenCode 无需手动 symlink 或配置文件编辑即可发现 sw-superpowers 技能。
    // 这有效是因为 Config.get() 返回缓存的单例——此处的修改在技能稍后延迟发现时可见。
    config: async (config) => {
      config.skills = config.skills || {};
      config.skills.paths = config.skills.paths || [];
      if (!config.skills.paths.includes(swSuperpowersSkillsDir)) {
        config.skills.paths.push(swSuperpowersSkillsDir);
      }
    },

    // 在每个会话的第一条用户消息中注入引导。
    // 使用用户消息而不是系统消息以避免：
    //   1. 每轮重复系统消息的 Token 膨胀 (#750)
    //   2. 多条系统消息破坏 Qwen 和其他模型 (#894)
    'experimental.chat.messages.transform': async (_input, output) => {
      const bootstrap = getBootstrapContent();
      if (!bootstrap || !output.messages.length) return;
      const firstUser = output.messages.find(m => m.info.role === 'user');
      if (!firstUser || !firstUser.parts.length) return;
      // 只注入一次
      if (firstUser.parts.some(p => p.type === 'text' && p.text.includes('EXTREMELY_IMPORTANT'))) return;
      const ref = firstUser.parts[0];
      firstUser.parts.unshift({ ...ref, type: 'text', text: bootstrap });
    }
  };
};
