#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay docker.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR/docker"
#ghostplay end

shellspec --docker fedora
