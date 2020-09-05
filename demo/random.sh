#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay random.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR/random"
#ghostplay end

shellspec --format documentation --random specfiles

#ghostplay sleep 2

shellspec --format documentation --random specfiles:99999
