# 贡献指南

感谢你愿意为 `doc-consistency-auditor` 做贡献。

## 先跑冒烟测试

任何改动前先确认当前基线是绿的：

```bash
bash tests/smoke_test.sh
```

## 提 issue

- **Bug**：请使用 `.github/ISSUE_TEMPLATE/bug_report.md` 模板，附上可复现的 Markdown 样例与期望/实际输出
- **新功能**：请使用 `.github/ISSUE_TEMPLATE/feature_request.md` 模板，说明动机与建议的规则编号

## 提 PR

1. Fork 本仓库并创建特性分支
2. 保持 `audit.py` **零第三方依赖**（只用标准库）
3. 新规则请遵循 `R<n>` 编号，并同步更新：
   - `SKILL.md` 的「检查规则明细」
   - `README.md` 的规则表
   - 相应 demo 样例与冒烟测试
4. 本地跑通 `bash tests/smoke_test.sh` 后再提交
5. 在 PR 描述里说明「改了什么 / 为什么 / 如何验证」

## 代码风格

- Python：PEP 8，4 空格缩进，中文注释
- 保持确定性：相同输入必须相同输出，不引入随机性、时间戳或网络请求
