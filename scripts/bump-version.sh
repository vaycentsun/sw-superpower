#!/bin/bash
# =============================================================================
# 统一版本号更新脚本
# =============================================================================
# 用法: ./scripts/bump-version.sh <新版本号>
# 示例: ./scripts/bump-version.sh 1.2.5
#
# 此脚本会从 VERSION 文件读取当前版本，并自动同步到所有需要版本号的地方。
# 以后每次升级，只需运行: ./scripts/bump-version.sh x.x.x
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$PROJECT_ROOT/VERSION"

# -----------------------------------------------------------------------------
# 读取当前版本
# -----------------------------------------------------------------------------
if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')
else
    echo "❌ 错误: VERSION 文件不存在于 $VERSION_FILE"
    exit 1
fi

# -----------------------------------------------------------------------------
# 获取新版本参数
# -----------------------------------------------------------------------------
NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
    echo ""
    echo "用法: $0 <新版本号>"
    echo ""
    echo "当前版本: $CURRENT_VERSION"
    echo ""
    echo "示例:"
    echo "  $0 1.2.5    # Patch 更新"
    echo "  $0 1.3.0    # Minor 更新"
    echo "  $0 2.0.0    # Major 更新"
    echo ""
    exit 1
fi

# -----------------------------------------------------------------------------
# 验证版本号格式 (语义化版本: x.x.x)
# -----------------------------------------------------------------------------
if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "❌ 错误: 版本号格式无效 '$NEW_VERSION'"
    echo "   应为语义化版本格式 x.x.x (如 1.2.5)"
    exit 1
fi

if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
    echo "⚠️  新版本与当前版本相同 ($CURRENT_VERSION)，无需更新"
    exit 0
fi

echo ""
echo "🚀 更新版本号: $CURRENT_VERSION → $NEW_VERSION"
echo ""

# -----------------------------------------------------------------------------
# 1. 更新 VERSION 文件（唯一版本号来源）
# -----------------------------------------------------------------------------
echo "$NEW_VERSION" > "$VERSION_FILE"
echo "   ✅ VERSION"

# -----------------------------------------------------------------------------
# 2. 更新 package.json（VS Code / npm 清单）
# -----------------------------------------------------------------------------
if [ -f "$PROJECT_ROOT/package.json" ]; then
    sed -i.bak "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/package.json"
    rm -f "$PROJECT_ROOT/package.json.bak"
    echo "   ✅ package.json"
fi

# -----------------------------------------------------------------------------
# 3. 更新 docs/install-opencode.md（安装指南中的版本引用）
# -----------------------------------------------------------------------------
if [ -f "$PROJECT_ROOT/docs/install-opencode.md" ]; then
    sed -i.bak "s/#v$CURRENT_VERSION/#v$NEW_VERSION/g" "$PROJECT_ROOT/docs/install-opencode.md"
    rm -f "$PROJECT_ROOT/docs/install-opencode.md.bak"
    echo "   ✅ docs/install-opencode.md"
fi

# -----------------------------------------------------------------------------
# 4. 更新 .codex-plugin/plugin.json（Codex 插件清单）
# -----------------------------------------------------------------------------
if [ -f "$PROJECT_ROOT/.codex-plugin/plugin.json" ]; then
    sed -i.bak "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/.codex-plugin/plugin.json"
    rm -f "$PROJECT_ROOT/.codex-plugin/plugin.json.bak"
    echo "   ✅ .codex-plugin/plugin.json"
fi

# -----------------------------------------------------------------------------
# 5. 更新 .zcode-plugin/plugin.json（ZCode 插件清单）
# -----------------------------------------------------------------------------
if [ -f "$PROJECT_ROOT/.zcode-plugin/plugin.json" ]; then
    sed -i.bak "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/.zcode-plugin/plugin.json"
    rm -f "$PROJECT_ROOT/.zcode-plugin/plugin.json.bak"
    echo "   ✅ .zcode-plugin/plugin.json"
fi

# -----------------------------------------------------------------------------
# 6. 更新 marketplace.json（ZCode 市场中插件条目的版本号；顶层整数 version 不动）
# -----------------------------------------------------------------------------
if [ -f "$PROJECT_ROOT/marketplace.json" ]; then
    sed -i.bak "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/marketplace.json"
    rm -f "$PROJECT_ROOT/marketplace.json.bak"
    echo "   ✅ marketplace.json"
fi

# -----------------------------------------------------------------------------
# 7. 更新 CHANGELOG.md（添加新版本条目）
# -----------------------------------------------------------------------------
if [ -f "$PROJECT_ROOT/CHANGELOG.md" ]; then
    TODAY=$(date +%Y-%m-%d)
    awk -v ver="$NEW_VERSION" -v today="$TODAY" '
        /^## \[Unreleased\]$/ {
            print
            print ""
            print "## [" ver "] - " today
            next
        }
        { print }
    ' "$PROJECT_ROOT/CHANGELOG.md" > "$PROJECT_ROOT/CHANGELOG.md.tmp"
    mv "$PROJECT_ROOT/CHANGELOG.md.tmp" "$PROJECT_ROOT/CHANGELOG.md"
    echo "   ✅ CHANGELOG.md"
fi

echo ""
echo "🎉 版本号同步完成!"
echo ""
echo "📋 接下来请手动完成以下步骤:"
echo ""
echo "   1. 检查 git diff 确认变更无误"
echo "      git diff"
echo ""
echo "   2. 检查 CHANGELOG.md 中的 [Unreleased] 条目，将已完成的变更移动到 [$NEW_VERSION] 下"
echo ""
echo "   3. 提交变更"
echo "      git add ."
echo "      git commit -m \"Bump version to $NEW_VERSION\""
echo ""
echo "   4. 打标签并推送（触发自动发布）"
echo "      git tag -a v$NEW_VERSION -m \"Release $NEW_VERSION\""
echo "      git push origin main --tags"
echo ""
