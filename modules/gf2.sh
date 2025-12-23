#!/usr/bin/env bash

setup_gf2() {
  local REPO_URL="https://github.com/nakst/gf.git"
  local INSTALL_PATH="/usr/local/bin/gf2"

  echo "==> Setting up gf2"

  if [ ! -d "./tmp/gf" ]; then
    echo "Cloning gf..."
    git clone "$REPO_URL" "./tmp/gf"
  else
    echo "Updating gf..."
    git -C "./tmp/gf" pull
  fi

  echo "Building gf2..."
  (
    cd ./tmp/gf
    ./build.sh
    # cd ../..
  )

  if [ ! -f "./tmp/gf/gf2" ]; then
    echo "Error: gf2 binary not found after build"
    exit 1
  fi

  echo "Installing gf2 to $INSTALL_PATH"
  sudo install -m 0755 "./tmp/gf/gf2" "$INSTALL_PATH"

  echo "[OK] gf2"
}
