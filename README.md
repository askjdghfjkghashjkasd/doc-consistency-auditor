# doc-consistency-auditor

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.8%2B-3776AB.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)
![Status](https://img.shields.io/badge/status-stable-green.svg)

> **一句话**：输入一个 Markdown 文件或目录，输出一份带「文件:行号」的一致性审计报告（终端 + Markdown + JSON），并用退出码 `0/1/2` 给出可机器判断的结论。

`doc-consistency-auditor` 是一个纯 Python 标准库（**零第三方依赖**）的确定性命令行工具，专门扫出多人协作或 AI 批量产出 Markdown 文档时最常见的五类「看不见的坑」。

## 它解决什么问题

| 规则 | 检查内容 | 级别 |
|------|----------|------|
| R0 | 文件规模：超大文件跳过并告警 | 警告 |
| R1 | 术语漂移：命中术语表禁用写法（如 `github` → `GitHub`） | 错误 |
| R2 | 内部链接/锚点：本地目标不存在、锚点未命中标题 | 错误 |
| R3 | 标题层级跳跃：`##` 直接跳 `####` | 警告 |
| R4 | 重复标题：同文件同 slug 标题重复 | 警告 |
| R5 | 交付物清单缺口：manifest 中 glob 未命中任何文件 | 警告 |

## 特性

- ✅ **零依赖**：只用 `argparse / os / re / json / fnmatch / sys`，`python3 audit.py` 直接跑
- ✅ **确定性**：相同输入必然相同输出，可挂进 CI / git pre-commit hook
- ✅ **精确到行**：每条问题都带「文件:行号 + 规则 + 修复建议」
- ✅ **三种输出**：终端、Markdown 报告、JSON（供脚本消费）
- ✅ **离线安全**：不做任何网络请求，外部链接自动跳过
- ✅ **自包含冒烟测试**：`tests/smoke_test.sh` 一条命令复现三态自测

## 安装

无需 pip 安装。克隆仓库即可使用：

```bash
git clone https://github.com/askjdghfjkghashjkasd/doc-consistency-auditor.git
cd doc-consistency-auditor
```

前置条件：Python 3.8+（只使用标准库）。

## 快速开始

```bash
# 1) 最简：审计单个文件（无术语表时跳过 R1）
python3 scripts/audit.py --path demo/sample_clean.md

# 2) 完整：术语 + 链接 + 标题 + 交付物清单
python3 scripts/audit.py --path demo \
  --glossary references/glossary.example.yaml \
  --manifest references/manifest.example.yaml

# 3) 机器可读 JSON
python3 scripts/audit.py --path demo --json

# 4) 自包含冒烟测试（验证三态退出码 0/1/2）
bash tests/smoke_test.sh
```

## 使用示例

审计一个含已知错误的样例，工具会精确定位到行：

```bash
$ python3 scripts/audit.py --path demo/sample_bad.md --glossary references/glossary.example.yaml

⚠️  审计发现 7 个问题（错误 6，警告 1）：
  [01] [错误] R1 @ sample_bad.md:11
        出现禁用写法「github」
        建议：统一为「GitHub」
  ...
```

> 完整可复现示例见 `demo/`：`sample_clean.md` 应通过（退出码 0），`sample_bad.md` 含 7 个已知问题（退出码 1）。

## 项目结构

```
doc-consistency-auditor/
├── README.md               # 本文件
├── LICENSE                 # MIT
├── .gitignore
├── AI_LOG.md               # AI 协作日志（多轮迭代）
├── ATTRIBUTION.md          # 拿来说明（来源与归属）
├── AAR.md                  # 七维复盘
├── CONTRIBUTING.md         # 贡献指南
├── CHANGELOG.md            # 版本记录
├── SKILL.md                # 技能定义（触发短语 + 工作流 + 边界）
├── scripts/
│   └── audit.py            # 核心审计脚本（纯标准库）
├── references/
│   ├── glossary.example.yaml    # 术语表样例
│   └── manifest.example.yaml    # 交付物清单样例
├── demo/
│   ├── sample_clean.md     # 干净样例（应通过）
│   ├── sample_bad.md       # 坏样例（含 7 个已知问题）
│   └── demo.png            # 运行截图
├── tests/
│   └── smoke_test.sh       # 自包含冒烟测试
├── dist/
│   └── doc-consistency-auditor.skill   # 打包的技能包
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── bug_report.md
    │   └── feature_request.md
    └── PULL_REQUEST_TEMPLATE.md
```

## 贡献

欢迎提 issue 或 PR，详见 [CONTRIBUTING.md](CONTRIBUTING.md)。改动前请先跑 `bash tests/smoke_test.sh`，确认不破坏现有行为。

## 许可证 / 归属

- 代码以 [MIT License](LICENSE) 开源
- 来源与归属详见 [ATTRIBUTION.md](ATTRIBUTION.md)
- AI 协作过程见 [AI_LOG.md](AI_LOG.md)，复盘见 [AAR.md](AAR.md)
