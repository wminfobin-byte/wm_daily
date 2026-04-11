#!/bin/bash
# wmdaily 배포 스크립트
# 사용법: bash deploy.sh
# origin(wm_daily) + pages(wmdaily) 두 레포에 한번에 push

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PAGES_REPO="https://github.com/wminfobin-byte/wmdaily.git"
TMP_DIR="/tmp/wmdaily_deploy_$$"

cd "$SCRIPT_DIR"

# 1. 커밋 안 된 변경 확인
if ! git diff --quiet -- index.html logo.png CLAUDE.md 2>/dev/null; then
  echo "[!] 커밋되지 않은 변경이 있습니다. 먼저 커밋해주세요."
  git diff --stat -- index.html logo.png CLAUDE.md
  exit 1
fi

# 2. origin(wm_daily)에 push
echo "[1/4] origin(wm_daily)에 push..."
git stash -q 2>/dev/null || true
git pull --rebase origin main 2>/dev/null || true
git stash pop -q 2>/dev/null || true
git push origin main
echo "  -> origin push 완료"

# 3. pages 레포 clone
echo "[2/4] pages 레포 clone..."
git clone --depth 1 "$PAGES_REPO" "$TMP_DIR" 2>/dev/null

# 4. 파일 복사
echo "[3/4] 파일 복사..."
cp "$SCRIPT_DIR/index.html" "$TMP_DIR/index.html"
cp "$SCRIPT_DIR/logo.png" "$TMP_DIR/logo.png" 2>/dev/null || true
cp "$SCRIPT_DIR/CLAUDE.md" "$TMP_DIR/CLAUDE.md" 2>/dev/null || true

# 변경 있는지 확인
cd "$TMP_DIR"
if git diff --quiet; then
  echo "  -> pages 레포에 변경 없음. 이미 최신입니다."
  rm -rf "$TMP_DIR"
  exit 0
fi

# 5. commit + push
echo "[4/4] pages(wmdaily)에 push..."
LAST_MSG=$(cd "$SCRIPT_DIR" && git log -1 --format="%s")
git add -A
git commit -m "$LAST_MSG"
git push origin main
echo "  -> pages push 완료"

# 정리
rm -rf "$TMP_DIR"

echo ""
echo "배포 완료! GitHub Pages 반영까지 1~2분 소요됩니다."
