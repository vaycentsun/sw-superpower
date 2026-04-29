# sw-superpower — Agent Context

> **What this repo is:** A Superpowers-style skill framework for OpenCode. The "source code" is SKILL.md markdown files in `sw-*/` directories, not a traditional code project. This is a Chinese-localized fork of [obra/superpowers](https://github.com/obra/superpowers).

## What You Must Know Before Editing

### This Is a Skill Framework, Not an App
- The "source" is SKILL.md files in `sw-*/` directories. There is no `npm test`, no build step, and no traditional app entrypoint.
- `package.json` exists solely so OpenCode can install the plugin via `git+` URL. Do not add dependencies or scripts to it.
- The plugin at `.opencode/plugins/sw-superpowers.js` injects skills into sessions via two hooks:
  - `config` — registers the repo root in `config.skills.paths` so OpenCode discovers `sw-*/SKILL.md` files.
  - `experimental.chat.messages.transform` — prepends `sw-using-superpowers/SKILL.md` content (plus tool mappings) into the first user message of each session.

### File Path Conventions
- **Spec files**: `dev/specs/YYYY-MM-DD--<feature-name>-design.md`
- **Plan files**: `dev/specs/plans/YYYY-MM-DD--<feature-name>-plan.md`
- **Skill directories**: `sw-<skill-name>/`
- **Subagent prompts**: `subagent-prompts/<name>-prompt.md`

### Instruction Priority (Framework Design)
Superpowers skills override default system prompts, but **user instructions always win**:
1. User explicit instructions (CLAUDE.md, GEMINI.md, AGENTS.md, direct request) — highest
2. Superpowers skills — overrides default behavior
3. Default system prompts — lowest

If you edit skills that contain hard rules (e.g. "always use TDD"), do not weaken them. The framework is designed to be rigid on workflow discipline.

### Pre-Push Hook — Activate It
```bash
ln -s ../../hooks/pre-push .git/hooks/pre-push
```
The hook enforces SKILL.md constraints. **Known bug:** the code checks `> 500` lines but the message says "上限 600". If you edit the hook, fix this discrepancy.

### How to Verify Changes
```bash
# Run the bash test suite (not npm test)
bash tests/opencode/run-tests.sh

# Run a single test
bash tests/opencode/run-tests.sh -t test-skill-structure.sh
```

### Skill File Constraints (Enforced by Hook + Tests)
| Constraint | Detail |
|------------|--------|
| **Frontmatter** | Must start with `---` and contain `name:` + `description:` |
| **Line limit** | ~500–600 lines. Split into separate `.md` files if a skill grows larger (see `sw-writing-skills/` as the model: `SKILL.md` + `cso-guide.md` + `skill-creation-workflow.md`). |
| **Red Flags** | Must include a `## 红旗` or `## Red Flags` section |
| **Common Excuses** | Must include a table of common excuses (e.g. `| 想法 | 现实 |`) |
| **Naming** | Directory must match `sw-<skill-name>/` and the frontmatter `name:` field |

### Skill Frontmatter Format
```markdown
---
name: sw-example
description: "Use when [specific trigger condition]"
---
```
**Important:** The plugin's frontmatter parser is a simple colon-based parser (see `.opencode/plugins/sw-superpowers.js`). Do not use complex YAML features like multi-line strings or nested objects.

## Architecture

```
sw-superpower/
├── sw-*/                  # 14 skill directories, each with SKILL.md (+ optional subagent-prompts/, templates/, scripts/)
├── .opencode/plugins/      # OpenCode plugin: sw-superpowers.js (auto-registers skills + injects bootstrap)
├── tests/opencode/         # Bash test suite (3 tests: plugin-loading, skill-structure, tool-mapping)
├── hooks/                  # Git hooks (pre-push validation)
├── docs/                   # Human-facing docs
└── package.json            # Required for OpenCode plugin installation via git URL
```

## How the Plugin Works
1. **Config hook:** Adds the repo root to `config.skills.paths`, so OpenCode discovers `sw-*/SKILL.md` files.
2. **Transform hook:** On the first user message of each session, prepends the content of `sw-using-superpowers/SKILL.md` (plus OpenCode tool mappings) as a user message part.
3. **Effect:** Agent sees "You have superpowers" context automatically, without manually loading skills.

## Installation Methods

**Plugin (global, recommended):**
Add to `~/.config/opencode/opencode.json`:
```json
{
  "plugin": ["sw-superpower@git+http://192.168.1.100:53000/vaycent/sw-superpower.git#main"],
  "permission": { "skill": { "*": "allow" } }
}
```
Restart OpenCode. The plugin installs automatically via Bun.

**Git submodule (project-local):**
```bash
cd <project>/skills/
git submodule add https://github.com/vaycentsun/sw-superpower.git
```

## When Adding or Editing a Skill
1. Create directory `sw-<name>/` with `SKILL.md`.
2. Include frontmatter, Red Flags, and Common Excuses table.
3. Run `bash tests/opencode/run-tests.sh` before committing.
4. Ensure `git push` passes the pre-push hook.
5. If a skill exceeds the line limit, split it into multiple `.md` files within the same `sw-*/` directory (reference `sw-writing-skills/` structure).

## Files to Ignore
- `.opencode/node_modules/`, `.opencode/package*.json` — plugin dev dependencies, not project source.
- `tests/opencode/*.sh` output — tests are self-contained and stateless.

## Related Docs
- `docs/install-opencode.md` — Human-facing OpenCode installation guide
- `sw-writing-skills/SKILL.md` — Meta-skill for creating new skills
- `tests/README.md` — Test suite documentation
