# AAR（After Action Review）— C5 GitHub Repository

> 七维复盘：学到了什么 / 过程 / 与 AI 协作 / 完成了什么 / 卡点与突破 / 改进方向 / ΔR 归因。

## 一、学到了什么

- 一个「能跑的程序」≠ 一个「合格的开源仓库」。后者需要 README、License、`.gitignore`、贡献指南、issue/PR 模板、版本记录（CHANGELOG）、归属说明（ATTRIBUTION）这一整套「开源基础设施」，它们共同回答了三个问题：**这项目是什么？怎么用？别人怎么安全地参与进来？**
- 可复现性比「我觉得对」可靠：用 `sha256` 核验移植是否逐字节一致，用退出码核验程序三态（0/1/2），而不是靠肉眼或主观判断。
- 自动化测试和手动验证要互相印证；当两者矛盾时，**先读源码确认契约**，而不是先怀疑测试。

## 二、过程（做了什么，按顺序）

1. **方向决策**：确定复用 C4 已验证的 `doc-consistency-auditor` 技能作为 C5 的项目本体。
2. **仓库结构设计**：决定技能源码提到仓库根目录（`scripts/`、`references/`、`demo/`、`tests/` 平铺），放弃子目录嵌套。
3. **开源层补齐**：写 README、LICENSE(MIT)、.gitignore、ATTRIBUTION、CONTRIBUTING、CHANGELOG(1.1.0)、issue 模板×2、PR 模板。
4. **技能本体移植**：复制 SKILL.md / audit.py / references / demo，并逐字节 sha256 核验（7 个关键文件全部一致）。
5. **本地真实自测**：audit.py 三态退出码 0/1/2 全部符合预期；坏样例报 7 个问题（6 错误 1 警告）。
6. **复盘与说明**：写 AI_LOG.md（本文件）与 AAR.md。
7. **推送与提交**：推到 GitHub，再提交平台。

## 三、与 AI 的协作（分工与边界）

- **我（人类）主导的**：方向决策（复用 C4 技能）、确认仓库公开、提供 GitHub 凭据、最终点提交确认。
- **AI 主导的**：需求澄清、结构设计、文档撰写、自测执行、复盘写作、推送执行。
- **明确边界**：AI 不拥有凭据、不替我做提交确认；凭据用完需自行 Revoke。这个边界让「AI 尽可能多做」与「关键决定/授权由人掌控」同时成立。

## 四、完成了什么（可验证的产物）

| 类别 | 产物 |
|---|---|
| 核心代码 | `scripts/audit.py`（358 行，纯标准库，零第三方依赖）|
| 技能规范 | `SKILL.md`（审计规则 R0–R5）|
| 配置样例 | `references/glossary.example.yaml`、`references/manifest.example.yaml` |
| 演示 | `demo/sample_clean.md`、`demo/sample_bad.md`、`demo/demo.png` |
| 测试 | `tests/smoke_test.sh`（三态退出码自包含冒烟测试，通过）|
| 开源层 | README / LICENSE(MIT) / .gitignore / ATTRIBUTION / CONTRIBUTING / CHANGELOG / issue×2 / PR 模板 |
| 打包 | `dist/doc-consistency-auditor.skill` |
| 记录 | `AI_LOG.md`、`AAR.md` |

## 五、卡点与突破

- **卡点 1：自测出现"假绿"与"假红"并存的矛盾。** 现象：`smoke_test.sh` 报通过，但我手动直接调用 `audit.py demo/sample_clean.md` 三态全部退出 2。
- **突破**：读 `audit.py` 的 `main()`，发现契约是 `--path`（`argparse` 要求的具名参数），位置参数会被拒（退出 2）。`smoke_test.sh` 用对了 `--path`，所以它是真绿；是我调用姿势错了。改用 `--path` 后三态 0/1/2 全部正确。
- **教训**：遇到「测试说行、手动说不行」的矛盾，先看源码契约，而不是立刻怀疑测试或怀疑程序。

## 六、改进方向（如果重来 / 下一步）

1. **加 CI**：用 GitHub Actions 在每次 push 后自动跑 `tests/smoke_test.sh`，把「人工自测」升级为「自动门禁」（rubric 里 CI/CD 是可选加分项，本次未做）。
2. **补覆盖率**：当前自测只覆盖三态退出码，未覆盖 R2/R3/R4 每条规则的分支细节；可加 pytest 式单元测试逐规则断言。
3. **规范化发布**：把 `dist/*.skill` 的打包流程脚本化（一条命令产出 `.skill` + demo.png + 校验），避免手工打包。
4. **文档多语言**：README 目前中文为主，可补英文版以扩大受众。

## 七、ΔR 归因（结果好在哪里 / 差在哪里）

- **「复用 C4 技能」这个决定贡献了大部分质量（ΔR 为正）**：它让我把 C5 的有限精力投在「开源化」这件事上，而不是重新发明审计器；最终仓库既有真实可运行的代码，又有完整的开源外衣。
- **「自测矛盾排查」贡献了正确性（ΔR 为正）**：如果没有停下来读源码，我可能会带着一个"手动调用失败"的错觉去提交，或在 README 里写错用法。
- **「未做 CI」是本次最大的可改进项（ΔR 为负但已知）**：rubric 把它列为可选加分，受时间约束暂缓，已列入改进方向第 1 条，不是遗漏而是取舍。
