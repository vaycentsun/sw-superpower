# AI Installation Guide for sw-agiledevelopment (ZCode)

This guide is written for an AI coding agent. When a user asks you to install
`sw-agiledevelopment` for **ZCode**, follow these steps and perform the work
yourself when you have permission.

## Goal

Install the `sw-agiledevelopment` plugin into the user's ZCode environment so
that the agile development skills are available globally in every ZCode session,
with the `sw-using-agiledevelopment` bootstrap content auto-injected on session
start.

## What this installs

- Marketplace source: `vaycentsun/sw-agiledevelopment` (the repository root
  carries a ZCode `marketplace.json`; the plugin itself is the repo root)
- Plugin name: `sw-agiledevelopment`
- Plugin version: see the `VERSION` file (currently `1.4.0`)
- Plugin capabilities: **ZCode Skills only**. This plugin does not expose MCP
  tools or callable functions. It injects a bootstrap context via a `SessionStart`
  hook.

## How the plugin is structured

The plugin manifest lives at `.zcode-plugin/plugin.json` and declares:

- `"skills": "skills"` — the repository-root `skills/` directory (a set of
  symlinks to the real `sw-*/` source directories, so all agent platforms share
  one copy of the content);
- `"hooks": ".zcode-plugin/hooks/hooks.json"` — a `SessionStart` hook that reads
  `sw-using-agiledevelopment/SKILL.md` and injects it into each new session.
  This is what makes the agile workflow reliably activate.

## Prerequisites

1. Confirm the user wants this installed in their ZCode environment.
2. Confirm a ZCode installation is present. Look for the ZCode config directory
   at `~/.zcode/cli/plugins/`.
3. For the UI-free fallback only: `git`, `bash`/`zsh`, and `python3` (on Windows
   the polyglot `run-hook.cmd` wrapper locates bash automatically at hook
   runtime).

If ZCode is not present at all, stop and tell the user ZCode must be installed
first.

## Install Steps

### Option A — ZCode marketplace (preferred)

This is the path that gives the user one-click upgrades later.

1. In the ZCode client, open **Settings → Plugin Management → Discover**.
2. Click the **+** button and add the marketplace:
   `vaycentsun/sw-agiledevelopment`
   (a GitHub repository; a full Git URL also works:
   `https://github.com/vaycentsun/sw-agiledevelopment.git`).
3. Find the `sw-agiledevelopment` plugin card and click **Get**. New plugins
   are enabled by default.
4. Fully restart ZCode (Cmd + Q / Quit, then reopen) if the skills do not
   appear in the current session.

If you are an agent performing this for the user and cannot drive the UI, use
Option B instead.

**Upgrading (Option A installs):** when the repository publishes a new version,
the Discover/Installed view shows an update for the plugin; clicking it pulls
the latest commit. No manual steps are needed.

### Option B — UI-free filesystem install (fallback)

Use this when the marketplace UI is unavailable or the install must be
scripted. ZCode discovers user plugins through `plugins.dirs` in
`~/.zcode/cli/config.json`; the installer clones the repository and registers
the clone directory there.

```bash
git clone https://github.com/vaycentsun/sw-agiledevelopment.git \
  "$HOME/.zcode/cli/plugins/cache/sw-agiledevelopment-src/sw-agiledevelopment"

bash "$HOME/.zcode/cli/plugins/cache/sw-agiledevelopment-src/sw-agiledevelopment/scripts/install-zcode.sh"
```

The script clones (or updates) the repository, registers it in
`~/.zcode/cli/config.json`, and verifies the SessionStart hook. Then fully
restart ZCode.

**Upgrading (Option B installs):** re-run `install-zcode.sh`; it pulls the
latest `main` and re-verifies the hook.

## Verify installation

1. Confirm the manifest is valid and its version matches the `VERSION` file:

```bash
python3 -c "import json; m=json.load(open('.zcode-plugin/plugin.json')); print(m['version'], m['skills'], m['hooks'])"
```

2. Confirm the SessionStart hook runs and emits valid JSON context:

```bash
bash .zcode-plugin/hooks/session-start | python3 -m json.tool > /dev/null && echo "hook OK"
```

This should print `hook OK`. If it prints nothing or errors, the skills path or
symlinks are wrong — re-check that the clone is intact and
`skills/sw-using-agiledevelopment/SKILL.md` resolves.

3. Or run the full structural check from the repository root:

```bash
bash scripts/verify-zcode.sh
```

4. Fully restart ZCode (not just a new session). After restart, open
   **Settings → Plugin Management**: `sw-agiledevelopment` should be listed and
   enabled. New sessions will auto-inject the bootstrap; the `sw-*` skills
   appear under **Settings → Skills**.

## Success Message

When complete, tell the user:

```text
sw-agiledevelopment has been added to ZCode. Fully restart ZCode so the
plugin, skills, and SessionStart bootstrap appear, then ask it to use the agile
development workflow.
```

## Troubleshooting

- **Marketplace add fails (network / GitHub access):** ask permission to retry
  with network access, or ask the user to check their connection. Behind a
  proxy, set `ZCODE_HTTP_PROXY=http://host:port` (ZCode reads the proxy only
  from this variable). Fallback to Option B.
- **Plugin still does not appear after install:** make sure you fully restarted
  ZCode (Cmd + Q / Quit, then reopen). Plugin discovery happens at app startup.
- **Skills present but bootstrap not activating:** the SessionStart hook did not
  run. Open the plugin's detail view in **Settings → Plugin Management** and
  confirm the `SessionStart` hook is listed and runnable; verify `bash` is
  available and `.zcode-plugin/hooks/` contains `hooks.json`, `run-hook.cmd`,
  and `session-start`.
- **`session-start` exits with empty output:** confirm `skills/` resolves to the
  real `sw-using-agiledevelopment/` directory. The hook reads
  `${REPO_ROOT}/skills/sw-using-agiledevelopment/SKILL.md`.
- **`@sw-agiledevelopment` is recognized but skills are absent in the current
  session:** this is usually a session-refresh issue. Start a new ZCode session
  after installation. The plugin provides Skills such as
  `sw-requirements-clarification` and `sw-test-driven-dev`; it does not provide
  MCP tools.
- **Windows:** the `skills/` directory uses symlinks, which require Git for
  Windows to be installed with symlink support (or Developer Mode enabled).
  Without it, git checks the symlinks out as plain text files and skill
  discovery fails. macOS and Linux are unaffected.
