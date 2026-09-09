# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.4.1] - 2026-09-09

### Added
- Root `marketplace.json` so the repository can be added directly as a ZCode marketplace (Settings → Plugin Management → Discover → +), giving users one-click installs and upgrades.
- `scripts/verify-zcode.sh` now also checks that `plugin.json` version matches `VERSION`, that the manifest declares hooks, and that `marketplace.json` is valid.

### Fixed
- Synchronized `.zcode-plugin/plugin.json` version with `VERSION` (`1.4.0`).
- Declared `"hooks": ".zcode-plugin/hooks/hooks.json"` in the ZCode manifest and fixed the hook command path to resolve `run-hook.cmd` under `.zcode-plugin/hooks/`, so the SessionStart bootstrap loads when the plugin is installed from a marketplace.
- `scripts/bump-version.sh` now keeps `.zcode-plugin/plugin.json` and `marketplace.json` in sync on future releases.

### Changed
- Simplified `scripts/install-zcode.sh`: it now registers the clone directory directly in `plugins.dirs` instead of building a versioned symlink staging cache.
- Rewrote `.zcode-plugin/INSTALL.md` and the ZCode sections of `README.md` / `README.zh.md` for the marketplace install flow.

## [1.4.0] - 2026-06-25

### Changed
- Standardized all `## 红旗` section headers in skills to `## 红旗 - ...` format.
- Replaced hardcoded `/tmp/sw-agiledevelopment-check` paths in `.lingma/sw-agile-developer.md` with a generic placeholder.

### Fixed
- Added missing red-flag tables to `.androidstudio/sw-agiledevelopment.md` and `.lingma/sw-agile-developer.md`, eliminating bootstrap drift warnings.

### Added
- `scripts/validate-skill-descriptions.sh` to enforce CSO rules on all `SKILL.md` descriptions.
- Platform verification scripts: `verify-opencode.sh`, `verify-zcode.sh`, `verify-codex.sh`, `verify-copilot.sh`, `verify-lingma.sh`, and `verify-androidstudio.sh`.
- CSO validation is now part of the pre-push hook.

### Changed
- `sw-using-agiledevelopment/SKILL.md` description rewritten to comply with CSO rules.
- `.zcode-plugin/hooks/session-start` is now executable.

### Removed
- Deleted the `tests/` directory and its contents; this skill framework relies on the pre-push hook for SKILL.md validation rather than a standalone test suite.
- Removed references to the deleted test suite from `AGENTS.md`.

## [1.3.2] - 2026-06-25

### Changed
- Standardized red-flag table headers across all skills to `| 想法 | 现实 |`.
- Filled the placeholder red-flag section in `sw-writing-skills/SKILL.md`.
- Updated `sw-code-review` and `sw-task-verification` descriptions to start with `Use when`.
- Reduced `sw-subagent-development/SKILL.md` by removing a duplicated user-feedback block.
- Replaced the duplicate ZCode install guide in `.zcode/INSTALL.md` with a redirect to `.zcode-plugin/INSTALL.md`.
- Cleaned up expected-trigger formatting in `tests/skill-triggering/run-test.sh` and added `writing-specs.txt`.

### Fixed
- Synchronized `.codex-plugin/plugin.json` version with `VERSION` (`1.3.2`).
- Extended `scripts/bump-version.sh` to keep `.codex-plugin/plugin.json` in sync on future releases.
- Removed invalid `browser` field from `package.json`.
- Moved the deprecated `spec-document-reviewer-prompt.md` to `subagent-prompts/archive/`.

### Added
- `CHANGELOG.md` to track release history.
