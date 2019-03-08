#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay demo/demo.sh"
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR"
ghostplay_cleanup_handler() {
  cd "$SCRIPT_DIR"
  if [ -d project ]; then
    rm -rf project
  fi
}
#ghostplay end

# Create your project directory
mkdir project
cd project

#ghostplay sleep 3

# Initialize
shellspec --init

#ghostplay sleep 3

# Write your first specfile (of course you can use your favorite editor)
#ghostplay batch
cat << 'HERE' > spec/hello_spec.sh
Describe 'hello.sh'
  . lib/hello.sh
  Example 'hello'
    When call hello shellspec
    The output should equal 'Hello shellspec!'
  End
End
HERE
#ghostplay end

#ghostplay sleep 3

# Create lib/hello.sh
mkdir lib
#ghostplay batch
cat << 'HERE' > lib/hello.sh
hello() {
  :
}
HERE
#ghostplay end

#ghostplay sleep 3

# It goes fail because hello function not implemented.
shellspec

#ghostplay sleep 3

# Write hello function (of course you can use your favorite editor)
#ghostplay batch
cat << 'HERE' > lib/hello.sh
hello() {
  echo "Hello ${1}!"
}
HERE
#ghostplay end

#ghostplay sleep 3

# It goes success!
shellspec

# Done
