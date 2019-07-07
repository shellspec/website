#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay demo/rerun/rerun.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR"
#ghostplay end

shellspec

#ghostplay sleep 1

# I would like to execute only failure example

#ghostplay sleep 3
shellspec spec/calc_spec.sh:46
