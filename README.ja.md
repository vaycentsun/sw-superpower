<div align="right">
  <a href="./README.md">🇺🇸 English</a> | <a href="./README.zh.md">🇨🇳 中文</a> | <strong>🇯🇵 日本語</strong> | <a href="./README.es.md">🇪🇸 Español</a> | <a href="./README.fr.md">🇫🇷 Français</a>
</div>

# sw-superpower 🦸

> AI コーディングエージェント向けの Superpowers スタイルのスキルセット — ブレインストーミングからコードレビューまでの構造化されたソフトウェアエンジニアリングワークフロー

AI コーディングエージェントが、体系的かつ再現性のある方法で要件分析からコードレビューまでの各ステップを完了するのを支援する、完全なソフトウェアエンジニアリングワークフロースキルセットです。

---

## 📦 概要

`sw-superpower` は [OpenCode](https://opencode.ai) などの AI コーディングプラットフォーム向けに設計された Superpowers スタイルのスキルセットです。熟成されたソフトウェアエンジニアリングの実践（TDD、コードレビュー、体系的なデバッグ）を構造化され再利用可能なエージェントスキルとしてカプセル化しています。

### 核心理念

- **プロセス駆動**: 各スキルが明確なトリガー条件と実行ワークフローを定義
- **ルールファースト**: 譲れないルールを最前面に配置
- **ストレステスト**: TDD を通じてスキルを作成・検証
- **漸進的デリバリー**: ブレインストーミングからコードデリバリーまでの完全なワークフロー

---

## 🗂️ プロジェクト構造

```
sw-superpower/
├── sw-brainstorming/              # ブレインストーミングと要件分析
├── sw-writing-specs/              # 実装計画の作成
├── sw-subagent-development/       # サブエージェント駆動開発
├── sw-test-driven-dev/            # テスト駆動開発
├── sw-requesting-code-review/     # コードレビューの依頼
├── sw-receiving-code-review/      # コードレビューの受信
├── sw-systematic-debugging/       # 体系的なデバッグ
├── sw-dispatching-parallel-agents/# 並列エージェント派遣
├── sw-executing-plans/            # 計画の実行
├── sw-verification-before-completion/  # 完了前検証
├── sw-finishing-branch/           # 開発ブランチの完了
├── sw-using-superpowers/          # スキルシステムブートストラップ（コアエントリ）
└── sw-writing-skills/             # 新しいスキルの作成（メタスキル）
```

---

## 🚀 コアワークフロー

完全なソフトウェア開発ワークフローは以下の順序で実行されます：

```
新機能の開始
    ↓
sw-brainstorming (ブレインストーミングと設計)
    ↓ 出力: docs/sw-superpower/specs/YYYY-MM-DD--feature.md
sw-writing-specs (実装計画の作成)
    ↓ 出力: docs/sw-superpower/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (サブエージェント駆動開発)
    ├── sw-test-driven-dev (各タスクの TDD)
    ├── sw-requesting-code-review (タスク後のレビュー)
    └── sw-receiving-code-review (レビューフィードバックの処理)
    ↓
sw-verification-before-completion (完了前検証)
    ↓
sw-finishing-branch (ブランチ完了)
```

---

## 📋 スキル一覧

| スキル | 目的 | トリガー条件 |
|-------|------|-------------|
| **sw-brainstorming** | アイデアを完全な設計と仕様に変換 | 新機能開発の開始 |
| **sw-writing-specs** | 詳細な実装計画を作成 | 設計が承認され、実行計画が必要 |
| **sw-subagent-development** | サブエージェントを使用して計画を実行 | 実装計画があり、タスクが独立している |
| **sw-test-driven-dev** | RED-GREEN-REFACTOR サイクルを強制 | 機能の実装またはバグ修正 |
| **sw-requesting-code-review** | コードレビュー依頼（レビューエージェント派遣） | タスク完了後、マージ前 |
| **sw-receiving-code-review** | コードレビューフィードバックの処理 | コードレビューコメント受信時 |
| **sw-systematic-debugging** | 体系的なバグ調査 | バグ発見またはテスト失敗 |
| **sw-dispatching-parallel-agents** | 並列サブエージェントワークフロー | 2+ 独立したタスク |
| **sw-executing-plans** | 同じセッションで計画をバッチ実行 | 計画あり、サブエージェント不使用 |
| **sw-verification-before-completion** | 完了前の検証 | タスクを完了としてマークする準備完了 |
| **sw-finishing-branch** | 検証、判断、ブランチのクリーンアップ | すべてのタスクが完了 |
| **sw-writing-skills** | 新しいスキルを作成・検証 | 新しいスキルの作成が必要 |
| **sw-using-superpowers** | スキルシステムブートストラップ | すべての会話の開始時 |

---

## 🎯 クイックスタート

### インストール

**方法 1: OpenCode プラグイン（推奨）**

`~/.config/opencode/opencode.json` に追加：

```json
{
  "plugin": [
    "sw-superpower@git+http://192.168.1.100:53000/vaycent/sw-superpower.git#main"
  ],
  "permission": {
    "skill": {
      "*": "allow"
    }
  }
}
```

OpenCode を再起動すると、プラグインが Bun 経由で自動インストールされます。

**方法 2: Git サブモジュール**

```bash
cd <あなたのプロジェクト>/skills/
git submodule add https://github.com/vaycentsun/sw-superpower.git
git submodule update --init --recursive
```

後でサブモジュールを更新する場合：

```bash
cd <あなたのプロジェクト>/skills/sw-superpower
git pull origin main
cd <あなたのプロジェクト>
git add skills/sw-superpower
git commit -m "Update sw-superpower submodule"
```

または直接クローン（バージョン管理を使用するプロジェクトには推奨されません）：

```bash
cd <あなたのプロジェクト>/skills/
git clone https://github.com/vaycentsun/sw-superpower.git
```

OpenCode を再起動するか、スキルをリロードします。

### 使用例

新機能を開始すると、エージェントは自動的に適切なスキルを認識・適用します：

```
ユーザー: ユーザー認証機能を開発したい

エージェント: [自動的に sw-brainstorming スキルを適用]
      1. プロジェクトコンテキストを探索...
      2. 明確化の質問をする...
      3. 2-3 つのアプローチを提案...
      4. セクションごとに設計を提示...
      5. 仕様ドキュメントを作成 → docs/sw-superpower/specs/2026-04-18--user-auth.md
      6. sw-writing-specs を呼び出して実装計画を作成...
```

---

## 🏗️ スキル構造

各スキルは統一された構造に従った自己完結型のディレクトリです：

```
sw-<skill-name>/
├── SKILL.md                    # メインスキルファイル（必須）
├── subagent-prompts/           # サブエージェントプロンプト（オプション）
│   └── <name>-prompt.md

```

### SKILL.md 形式

```markdown
---
name: skill-name
description: "Use when [具体的なトリガー条件]"
---

# スキル名

## 鉄則
違反してはならない重要なルール

## プロセス
フローチャートと詳細なステップ

## レッドフラッグ - 即座に停止
違反の徴候リスト

## よくある言い訳表
| 言い訳 | 現実 |
|--------|------|

## 統合
前提条件と後続スキル

## 出力例
期待される出力形式
```

---

## 🔑 重要な原則

### YAGNI 原則

> You Aren't Gonna Need It（必要になることはない）

- 仕様に要求されていない機能を追加しない
- 過度に設計しない
- 将来の要件を想定しない

### サブエージェント開発の原則

- 各タスクに新しいサブエージェントを使用する
- サブエージェントはセッションコンテキストを継承すべきでない
- 完全なタスクテキストとコンテキストを提供する

### レビューの原則

- **客観的**: 個人の好みではなく基準に基づく
- **建設的**: 具体的な改善提案を提供する
- **優先順位付け**: 重要な問題に焦点を当てる

---

## 🧪 テスト戦略

このプロジェクトでは TDD を使用してスキルを開発します：

1. **テストファースト、スキルセカンド** - 例外なし
2. **ストレスシナリオの作成** - 3 つ以上の圧力組み合わせテスト
3. **ベースライン失敗の文書化** - スキルなしの失敗動作を観察
4. **失敗に対処するスキルの作成** - 観察された失敗を対象とする
5. **コンプライアンスの検証** - スキルで再テスト
6. **抜け穴の封鎖** - 新しい言い訳を見つけ、対策を追加

---

## 🤝 貢献

### 新しいスキルの作成

1. `sw-writing-skills` スキルを使用して作成プロセスをガイドする
2. TDD アプローチに従う：テストファースト、それから作成
3. 3 つ以上のストレスシナリオテストを作成
4. ベースライン失敗動作を文書化
5. 特定の失敗に対処するスキルを作成
6. コンプライアンスを検証し、抜け穴を封鎖

### コミット規約

```bash
# 新しいスキルの作成
feat: add sw-<skill-name> for <purpose>

# 既存スキルの更新
fix: resolve <issue> in sw-<skill-name>

docs: update <section> in sw-<skill-name>
```

---

## 📄 ライセンス

[MIT](./LICENSE)

---

## 🙏 謝辞

- [Superpowers](https://github.com/anthropics/superpowers) スキル形式に基づく
- 熟成されたソフトウェアエンジニアリングの実践にインスパイアされた

---

<div align="center">

**AI プログラミングをより体系的で、予測可能で、高品質なものにする** 🚀

</div>
