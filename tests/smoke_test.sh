#!/usr/bin/env bash
# smoke_test.sh — 自包含冒烟测试（零外部依赖）
# 验证 audit.py 三态退出码：0=干净通过；1=发现问题；2=用法/路径错误
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AUDIT="$ROOT/scripts/audit.py"

fail() { echo "FAIL: $1"; exit 1; }

# 1) 干净样例应通过（退出码 0）
python3 "$AUDIT" --path "$ROOT/demo/sample_clean.md" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 0 ] || fail "干净样例期望退出码 0，实际 $rc"

# 2) 坏样例应发现问题（退出码 1）
python3 "$AUDIT" --path "$ROOT/demo/sample_bad.md" \
  --glossary "$ROOT/references/glossary.example.yaml" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 1 ] || fail "坏样例期望退出码 1，实际 $rc"

# 3) 不存在的路径应报参数错误（退出码 2）
python3 "$AUDIT" --path "$ROOT/does-not-exist" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 2 ] || fail "缺失路径期望退出码 2，实际 $rc"

echo "✅ smoke_test 通过：三态退出码 0/1/2 全部符合预期"
