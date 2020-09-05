#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay parallel.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR/parallel"
#ghostplay end

shellspec --format documentation

#ghostplay sleep 2

shellspec --format documentation --jobs 3
