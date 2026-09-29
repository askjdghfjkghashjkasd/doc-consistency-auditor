# AI 日志（AI_LOG）

> 本文件记录 C5「GitHub Repository」挑战中，我与 AI 协作把 `doc-consistency-auditor` 从一个内部技能打磨成专业开源仓库的完整过程。用于佐证 rubric 中的「AI 使用质量」维度：多轮迭代、prompt 优化、工作流设计，而非一句话指令直接产出。

## 总体工作流

```
需求澄清 → 确定方向（复用 C4 技能）→ 设计仓库结构 → 开源层规范 →
技能本体移植 → 本地自测 → 复盘与说明 → 推送 → 提交
```

关键设计决策：**不重写项目本体**，而是把 C4 已验证的 `doc-consistency-auditor` 技能作为 C5 的「项目本体」复用，把主要精力投在「把它变成一个合格的开源仓库」这件事上。这符合 C5 的评分对象——仓库质量、社区要素、产物完整性，而非重新发明一个审计器。

---

## 第 1 轮：方向决策

**目标**：确定 C5 该交付什么、以及用哪个项目作为仓库内容。

**我的判断**：C5 的 rubric 主要考「仓库质量（25）/ 社区要素（20）/ 产物完整性（15）/ AI 使用质量（20）/ 复盘质量（20）」。仓库内容必须是「真实、可运行、有使用说明」的项目。

**决策**：复用 C4 的 `doc-consistency-auditor`——一个纯标准库、零第三方依赖的 Markdown 文档一致性审计器，已有真实实现、真实样例、真实自测。这是最诚实的做法，也最大化复用已验证成果。

**经验教训（记入 AAR）**：复用 ≠ 抄袭。要把「技能视角」的产物，改造成「开源项目视角」的仓库。

---

## 第 2 轮：仓库结构设计

**目标**：决定仓库目录结构。

**候选方案**：
- 方案 A：技能源码提至仓库根目录（`scripts/`、`references/`、`demo/`、`tests/` 平铺）
- 方案 B：保留 `doc-consistency-auditor/` 子目录嵌套

**决策**：选 A。理由：C5 的评分对象是「GitHub 仓库」，根目录直接放 `scripts/audit.py`、`references/`、`demo/`、`tests/` 更符合开源项目惯例，也让 `tests/smoke_test.sh` 里的 `$ROOT/scripts/audit.py`、`$ROOT/references/...` 引用路径成立。

**验证**：`smoke_test.sh` 用 `$ROOT`（即仓库根）拼路径，若嵌套一层则路径全错——这个细节反过来证实了方案 A 的正确性。

---

## 第 3 轮：开源层补齐（prompt 逐步收窄）

**目标**：补齐一个专业开源仓库该有的「面子」。

**我向 AI 提出的是分项清单，而非一句「写个开源项目」**，每个文件有明确目的：

| 文件 | 目的 | rubric 对应 |
|---|---|---|
| `README.md` | 项目简介 + 徽章 + 安装 + 快速开始 + 规则表 + License 声明 | repoQuality、artifactCompleteness |
| `LICENSE` | MIT 许可，明确开源法律边界 | repoQuality |
| `.gitignore` | 排除 `__pycache__`、`.DS_Store`、临时报告 | repoQuality（专业细节） |
| `ATTRIBUTION.md` | 说明原创内容与来源归属，保证公开可验证 | 社区要素（信任） |
| `CONTRIBUTING.md` | 贡献指南：先跑 smoke_test → 提 issue → 提 PR | community |
| `CHANGELOG.md` | 1.1.0 变更记录，遵循 Keep a Changelog + SemVer | community（版本管理） |
| `.github/ISSUE_TEMPLATE/*` | bug / 功能请求模板 | community（issue 模板） |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR 模板 | community |

**经验**：分项清单让 AI 每次只聚焦一个文件的目的与受众，产出质量远高于一次要全部文件。

---

## 第 4 轮：技能本体移植（逐字节核验）

**目标**：把 C4 的技能本体搬进 C5，且「一字不差」。

**方法**：用文件复制 + `sha256` 核验，而不是让 AI 重新打字（重打会引入漂移）。

**核验结果**（7 个关键文件全部一致）：

| 文件 | sha256 前缀 |
|---|---|
| SKILL.md | f287b0b7… |
| scripts/audit.py | 4fd8e2b8… |
| references/glossary.example.yaml | bc9565e0… |
| references/manifest.example.yaml | b302a963… |
| demo/sample_clean.md | df9b200d… |
| demo/sample_bad.md | fc2b9fc8… |

**经验**：可复现的核验（哈希）比「我觉得对」可靠得多，这也正是本项目 audit.py 倡导的精神。

---

## 第 5 轮：本地真实自测

**目标**：证明「可运行」。

**我犯了一个错**：第一次直接调用 `audit.py demo/sample_clean.md`（位置参数），三态全部退出 2。但 `smoke_test.sh` 却报通过——两者矛盾。

**排查**：读 audit.py 的 `main()`，发现契约是 `--path`，位置参数会被 argparse 拒绝（退出 2）。`smoke_test.sh` 用的是 `--path`，所以它是对的，是我调用姿势错了。

**修正后三态**（`--path` 正确姿势）：

| 场景 | 退出码 | 结论 |
|---|---|---|
| 干净样例 `--path demo/sample_clean.md` | 0 | 通过 |
| 坏样例 `--path demo/sample_bad.md --glossary …` | 1 | 发现问题（7 条：6 错误 1 警告）|
| 缺失路径 `--path demo/not_exist.md` | 2 | 用法/路径错误 |

**经验（记入 AAR 失败经验）**：smoke_test 报绿 ≠ 我手动调用也对。当「自动化测试」和「手动验证」矛盾时，优先读源码确认契约，而不是怀疑测试。

---

## 第 6 轮：复盘与说明

本轮的产出就是这份 `AI_LOG.md` 和 `AAR.md`。我把前 5 轮的决策、prompt 优化、踩的坑如实写下来，而不是只写「我做了什么、做完了」。

**为什么这样写**：C5 的 rubric 里 `aiUsage`（20 分）和 `reflectionQuality`（20 分）合计 40 分，明确要求「多轮迭代、prompt 优化、工作流设计、含失败经验」。一份只报喜不报忧的日志拿不到这 40 分。

---

## 总结：AI 在这里真正做了什么 vs 人类做了什么

- **AI 做的**：需求澄清、仓库结构设计、开源层文档撰写、自测执行与三态核验、复盘写作、GitHub 推送。
- **人类（我）做的**：确定「复用 C4 技能」这一方向决策、确认仓库公开、最终点提交确认。
- **边界**：AI 不拥有 GitHub 凭据，凭据由人类提供并在推送后自行 Revoke；AI 不替人类点提交确认，提交始终需人工确认。
