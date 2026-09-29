# 拿来说明（ATTRIBUTION）

本文档说明 `doc-consistency-auditor` 的内容来源与归属，保证公开、可验证。

## 原创内容

以下为本项目原创，MIT 许可开源：

- `scripts/audit.py` —— 审计脚本（R0–R5 规则、极简 YAML 解析、三态输出）
- `SKILL.md` —— 技能定义文档
- `references/glossary.example.yaml`、`references/manifest.example.yaml` —— 术语表 / 交付物清单样例（演示用，非真实数据）
- `demo/sample_clean.md`、`demo/sample_bad.md` —— 演示样例
- `tests/smoke_test.sh` —— 自包含冒烟测试
- 各文档：README / AI_LOG / AAR / CONTRIBUTING / CHANGELOG

## 依赖与运行环境

- **Python 3.8+**：仅使用标准库（`argparse / os / re / json / fnmatch / sys`），无第三方依赖
- 运行平台：macOS / Linux / Windows 均可

## 借鉴与参考

- 标题锚点 slug 规则参考 **GitHub Flavored Markdown** 的锚点生成约定（小写、空格/下划线转连字符、去除标点、保留 CJK）
- 「极简 YAML 子集」是**自定义约束格式**，未引入 PyYAML，故无需遵循完整 YAML 1.2 规范
- `CHANGELOG.md` 格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循 [SemVer](https://semver.org/lang/zh-CN/)

## 未使用的第三方素材

本项目**不包含**任何第三方代码、字体、图片素材的复制；`demo/demo.png` 为本工具运行产出的原始截图。

## 归属

- 作者学号：2025105400130
- 仓库：https://github.com/askjdghfjkghashjkasd/doc-consistency-auditor
