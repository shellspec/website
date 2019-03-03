<script src="https://asciinema.org/a/231346.js" id="asciicast-231346" async data-autoplay="true" data-cols="100" data-rows="25"></script>

## Features

* Support POSIX compatible shell (dash, bash, ksh, busybox, etc...)
* BDD style syntax
* The specfile is a valid shell script language syntax
* Pure shell script implementation
* Minimum Dependencies (Use only a few POSIX compliant command)
* Nestable groups with scope like lexical scope
* Before / After hooks
* Skip / Pending
* Mocking and stubbing (temporary function override)
* Built-in simple task runner
* Modern reporting (colorize, failure line number)
* Extensible architecture (custom matcher, custom formatter, etc...)
* shellspec is tested by shellspec

## Specfile syntax

```sh
Describe 'sample' # Example group block
  Describe 'bc command'
    add() { echo " + " | bc; }

    Example 'perform addition' # Example block
      When call add 2 2 # Evaluation
      The output should eq 4  # Expectation
    End
  End

  Describe 'implemented by shell function'
    . ./mylib.sh # add() function defined

    Example 'perform addition'
      When call add 2 2
      The output should eq 4
    End
  End
End
```
