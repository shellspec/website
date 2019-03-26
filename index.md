---
layout: default
title: shellspec
---
# Let's test the your shell script!

## Get started!

<script src="https://asciinema.org/a/236735.js" id="asciicast-236735" async data-autoplay="true" data-cols="100" data-rows="25"></script>

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
Describe 'sample' # Example group
  Describe 'bc command'
    add() { echo "$1 + $2" | bc; }

    It 'performs addition' # Example
      When call add 2 3 # Evaluation
      The output should eq 5  # Expectation
    End
  End

  Describe 'implemented by shell function'
    Include ./mylib.sh # add() function defined

    It 'performs addition'
      When call add 2 3
      The output should eq 5
    End
  End
End
```

## Reporter

### Formatters

#### progress formatter (default)

<script src="https://asciinema.org/a/232403.js" id="asciicast-232403" async data-cols="100" data-rows="30"></script>

#### documentation formatter

<script src="https://asciinema.org/a/232401.js" id="asciicast-232401" async data-cols="100" data-rows="40"></script>

#### tap formatter

<script src="https://asciinema.org/a/232404.js" id="asciicast-232404" async data-cols="100" data-rows="12"></script>
