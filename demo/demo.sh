#!/bin/sh

#ghostplay silent
# asciinema rec -c "ghostplay demo.sh"
#curl -fsSL https://git.io/shellspec | sh -s -- --yes
SCRIPT_DIR=$(cd "$(dirname "${GP_SOURCE:-$0}")"; pwd)
cd "$SCRIPT_DIR"
ghostplay_cleanup_handler() {
  cd "$SCRIPT_DIR"
  if [ -d hello ]; then
    rm -rf hello
  fi
  if [ -d "$HOME/.local/bin/shellspec" ]; then
    rm "$HOME/.local/bin/shellspec"
  fi
  if [ -d "$HOME/.local/lib/shellspec" ]; then
    rm -rf "$HOME/.local/lib/shellspec"
  fi
}
#ghostplay end

# Install shellspec
curl -fsSL https://git.io/shellspec | sh -s -- --yes

#ghostplay sleep 2

# Create your project directory
mkdir hello
cd hello

#ghostplay sleep 2

# Initialize
shellspec --init

#ghostplay sleep 2

# Write your first specfile
#ghostplay batch
cat << 'HERE' > spec/hello_spec.sh
Describe 'hello.sh'
  Include lib/hello.sh
  Example 'hello'
    When call hello shellspec
    The output should equal 'Hello shellspec!'
  End
End
HERE
#ghostplay end

#ghostplay sleep 2

# Create lib/hello.sh
mkdir lib
#ghostplay batch
cat << 'HERE' > lib/hello.sh
hello() {
  :  not implemented
}
HERE
#ghostplay end

#ghostplay sleep 2

# It goes fail because hello function not implemented.
shellspec

#ghostplay sleep 2

# Write hello function
#ghostplay batch
cat << 'HERE' > lib/hello.sh
hello() {
  echo "Hello ${1}!"
}
HERE
#ghostplay end

#ghostplay sleep 2

# It goes success!
shellspec

# Done
