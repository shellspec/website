#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay demo/coverage.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR"
ghostplay_cleanup_handler() {
  cd "$SCRIPT_DIR"
  if [ -d coverage ]; then
    rm -rf coverage
  fi
}
#ghostplay end

shellspec --kcov --profile
