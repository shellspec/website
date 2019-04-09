---
layout: default
title: shellspec
---
# Let's test the your shell script!

[shellspec](https://github.com/ko1nksm/shellspec) is a BDD style unit testing framework for POSIX compatible shell script

## Get started!

<script src="https://asciinema.org/a/236735.js" id="asciicast-236735" async data-autoplay="true" data-cols="100" data-rows="25"></script>

## Features

* Support POSIX compatible shell (dash, bash, ksh, busybox, etc...)
* BDD style syntax
* The specfile is a valid shell script language syntax
* Pure shell script implementation
* Minimum Dependencies (Use only a few POSIX compliant command)
* Parallel execution
* Nestable groups with scope like lexical scope
* Before / After hooks
* Skip / Pending
* Data helper that easy to input from stdin
* Embedded text that easier to use than heredoc at indented code
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

## Why use shellspec?

### 1. It's a BDD style

shellspec is a BDD style unit testing framework. You can write specifications with
DSL that nearly to natural language. And also those DSL are structured and executable.

shellspec is created inspired by rspec, and it has a DSL suitable for shell scripts.
And it's a readability even if you are not familiar with shell scripts syntax.

#### Comparison with other unit testing frameworks.

##### Comparison with Bats

* [Bats: Bash Automated Testing System](https://github.com/sstephenson/bats)
* [Bats-core: Bash Automated Testing System (2018)](https://github.com/bats-core/bats-core)

shellspec is less syntax of shell scripts specific, and you can write
specification in sentences nearly to natural language.

**bats**

```sh
#!/usr/bin/env bats

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  [ "$result" -eq 4 ]
}
```

**shellspec**

```sh
#shellcheck shell=sh

Example "addition using bc"
  When call "echo 2+2 | bc"
  The output should eq 4
End

Example "addition using dc"
  When call "echo 2 2+p | dc"
  The output should eq 4
End
```

##### Comparison with shunit2

[shUnit2 is a xUnit based unit test framework for Bourne based shell scripts.](https://github.com/kward/shunit2)

shellspec has structured DSL and readability.

**shunit2**

```sh
#! /bin/sh
# file: examples/math_test.sh

testAdding() {
  result=`add_generic 1 2`
  assertEquals \
      "the result of '${result}' was wrong" \
      3 "${result}"

  # Disable non-generic tests.
  [ -z "${BASH_VERSION:-}" ] && startSkipping

  result=`add_bash 1 2`
  assertEquals \
      "the result of '${result}' was wrong" \
      3 "${result}"
}

oneTimeSetUp() {
  # Load include to test.
  . ./math.inc
}

# Load and run shUnit2.
. ./shunit2
```

**shellspec**

```sh
#shellcheck shell=sh

Describe 'Adding'
  Include ./math.inc

  Describe 'generic'
    Describe 'add_generic()'
      It 'adds values'
        When call add_generic 1 2
        The output should eq 3
      End
    End
  End

  Describe 'non-generic'
    Skip if 'non-generic tests' [ -z "${BASH_VERSION:-}" ]

    Describe 'add_bash()'
      It 'adds values'
        When call add_bash 1 2
        The output should eq 3
      End
    End
  End
End
```

### 2. Modern reporting

shellspec has modern reporting similar like rspec. When specs fails, it reports
expected and actual with line number and colored.

shellspec has three reporting formatter, `progress`, `documentation`, `tap`.

#### progress formatter (default)

<script src="https://asciinema.org/a/232403.js" id="asciicast-232403" async data-cols="100" data-rows="30" data-autoplay="true"></script>

#### documentation formatter

<script src="https://asciinema.org/a/232401.js" id="asciicast-232401" async data-cols="100" data-rows="40" data-autoplay="true"></script>

#### tap formatter

<script src="https://asciinema.org/a/232404.js" id="asciicast-232404" async data-cols="100" data-rows="12" data-autoplay="true"></script>


### 3. Implements by pure POSIX compatible shell scripts

shellspec is implements by 100% pure POSIX compatible shell scripts.
The required external commands are basic few POSIX compliant commands only.

Not only bash, it supports dash, zsh, ksh, yash, posh and busybox ash. shellspec
is written by POSIX compatible syntax, but you can use extended syntax of bash, etc.

It works on Linux (e.g Debian, Alpine Linux on Docker, OpenWrt), macOS,
Unix (e.g. Solaris) and Windows Subsystem for Linux. Works in more environments.

### 4. The specfile is compatible with shell script syntax

The specfile looks like natural language, but also compatible with shell script
syntax. therefore you can mixing shell script code in specfile and also checking
syntax using by `sh -n`, `shellcheck` and so on.

The specfile is valid shell script syntax, but it extended. It supports nestable
block, scope and temporary function redefinition for mock/stub.

Those features is realized by code translation. The block of DSL translate to
subshell, it executes in own environment. This achieves isolation of tests.

### 5. And what you need

Besides, shellspec has the necessary features for unit testing.

* `Before` / `After` hooks for preparation and cleaning up.
* `Skip` for skipping tests.
* `Pending` to indicate the to be implementation.
* `Data` helper that easy to input from stdin.
* Embedded text that easier to use than heredoc at indented code.
* Built-in simple task runner

shellspec is designed with an extensible architecture, so you can create
custom matcher, custom modifier and so on.

shellspec is a powerful but simple to use. Let's enjoy test with [shellspec](https://github.com/ko1nksm/shellspec)!
