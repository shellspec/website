#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay tracing.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR/tracing"
#ghostplay end

shellspec --xtrace
