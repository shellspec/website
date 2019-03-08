#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay demo/formatters/documentation.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR"
#ghostplay end

shellspec --format documentation
