#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay quick.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR/quick"
: > .shellspec-quick.log
#ghostplay end

shellspec --quick

#ghostplay sleep 2

shellspec --quick

#ghostplay silent
: > .shellspec-quick.log
#ghostplay end
