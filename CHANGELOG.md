# Changelog

本项目的所有显著变更都会记录在此文件。格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循 [SemVer](https://semver.org/lang/zh-CN/)。

## [1.1.0] - 2026-09-29

### 新增
- 补全专业开源仓库要素：`LICENSE`（MIT）、`.gitignore`、`ATTRIBUTION.md`、`CONTRIBUTING.md`
- 新增 GitHub 社区模板：`.github/ISSUE_TEMPLATE/bug_report.md`、`feature_request.md`、`PULL_REQUEST_TEMPLATE.md`
- 新增自包含冒烟测试 `tests/smoke_test.sh`（一条命令复现三态退出码 0/1/2）
- 将技能包打包产物收录进 `dist/doc-consistency-auditor.skill`
- 重写 README：badges、特性、安装、快速开始、使用示例、项目结构

### 变更
- 项目从「课程交付物目录」重构为「独立可复用的开源仓库」，技能源码提至仓库根目录

## [1.0.0] - 2026-09-29

### 新增
- 首个可运行版本：`scripts/audit.py`（R0–R5 规则、退出码 0/1/2）
- `SKILL.md` 技能定义（触发短语 + 工作流 + 边界 + 示例）
- 术语表 / 交付物清单样例，demo 干净 / 坏样例
