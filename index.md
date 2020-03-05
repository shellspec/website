---
layout: default
title: shellspec
---
# Let's test the your shell script!

[shellspec](https://github.com/shellspec/shellspec) is a BDD style unit testing framework for POSIX compliant shell script

## Get started!

<div style="height: 30em; margin:0 auto">
<script src="https://asciinema.org/a/256723.js" id="asciicast-256723" async data-autoplay="true" data-cols="100" data-rows="25"></script>
</div>

Try the **[Online Demo](demo)** on the browser.

## Table of Contents

- [Get started!](#get-started)
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Why use shellspec?](#why-use-shellspec)
  - [1. Comparison list with other unit testing frameworks.](#1-comparison-list-with-other-unit-testing-frameworks)
  - [2. It's a BDD style](#2-its-a-bdd-style)
    - [Specfile syntax](#specfile-syntax)
    - [Comparison with Bats](#comparison-with-bats)
    - [Comparison with shunit2](#comparison-with-shunit2)
  - [3. Support nestable block with scope](#3-support-nestable-block-with-scope)
    - [Easy to mock / stub](#easy-to-mock--stub)
  - [4. Parameterized tests](#4-parameterized-tests)
  - [5. Fast testing and high portability](#5-fast-testing-and-high-portability)
  - [6. Modern reporting](#6-modern-reporting)
    - [progress formatter (default)](#progress-formatter-default)
    - [documentation formatter](#documentation-formatter)
    - [TAP formatter](#tap-formatter)
    - [JUnit XML formatter](#junit-xml-formatter)
  - [7. Coverage and profiler](#7-coverage-and-profiler)
  - [8. And what you need](#8-and-what-you-need)

## Introduction

shellspec was developed as a cross-platform testing tool for develop
POSIX-compliant shell scripts that work in many environments.
Works not only PC but also in restricted environments like cloud and embedded OS.
And provides first-class features equivalent to other language testing tools.
Of course shellspec is tested by shellspec.

## Why use shellspec?

### 1. Comparison list with other unit testing frameworks.

|                           | shellspec               | shunit2                   | bats / bats-core                |
| ------------------------- | ----------------------- | ------------------------- | ------------------------------- |
| Supported shells          | POSIX shell             | Bourne shell, POSIX shell | bash                            |
| Framework style           | BDD                     | xUnit                     | original                        |
| Spec / test syntax        | shell script compatible | shell script              | original                        |
| Nestable block with scope | support                 | -                         | -                               |
| Skip / Pending / Focus    | support (all)           | support (skip only)       | support (skip only)             |
| Mock / Stub               | support (built-in)      | -                         | - (extension exists)            |
| Parameterized tests       | support                 | -                         | -                               |
| Assertion line number     | support (all shells)    | support (limited shells)  | support (bash only)             |
| Parallel execution        | support                 | -                         | support (requires GNU parallel) |
| Random execution          | support                 | -                         | -                               |
| Filtering by name         | support                 | support                   | support                         |
| Filtering by line number  | support                 | -                         | -                               |
| TAP formatter             | support                 | -                         | support                         |
| JUnit XML formatter       | support                 | -                         | -                               |
| Coverage                  | support (requires kcov) | -                         | -                               |
| Profiler                  | support                 | -                         | -                               |

### 2. It's a BDD style

shellspec is a BDD style unit testing framework. You can write specifications with
DSL that nearly to natural language. And also those DSL are structured and executable.

shellspec is created inspired by rspec, and it has a DSL suitable for shell scripts.
And it's a readability even if you are not familiar with shell scripts syntax.

#### Specfile syntax

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

#### Comparison with Bats

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

#### Comparison with shunit2

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

### 3. Support nestable block with scope

shellspec supports nested block structure. It realize local variables and
functions that can only be used within a block.

#### Easy to mock / stub

This block structure also allows for simple and intuitive and
easy-to-understand mock / stub.

```sh
Describe 'mock / stub sample'
  unixtime() { date +%s; }

  Example 'The date command has been redefined'
    date() { echo 1546268400; }
    When call unixtime
    The output should eq 1546268400
  End

  Example 'The date command has not been redefined'
    When call unixtime
    The output should not eq 1546268400
  End
End
```

### 4. Parameterized tests

Supported parameterized tests to perform a test with only the parameters changed.
Also supported parameters by matrix definitions and dynamic parameters by code.

```
Describe 'example'
  Parameters
    "#1" 1 2 3
    "#2" 1 2 3
  End

  Example "example $1"
    When call echo "$(($2 + $3))"
    The output should eq "$4"
  End
End
```

### 5. Fast testing and high portability

"Fast" has two meanings. Testing cycles is fast, Execution speed is fast.

If failed your tests, display error with the line number.
You can re-run the failed tests with the line number.

<script src="https://asciinema.org/a/256058.js" id="asciicast-256058" async data-cols="100" data-rows="24"></script>

If you want to run specific test only, you can use `--focus` option to run
focused tests. (To focus, prepend 'f' to groups / examples in specfiles.
e.g. `Describe` -> `fDescribe`, `It` -> `fIt`, etc.)

If you want to temporarily skip some tests, prepend 'x' to groups / examples in
specfiles (like `xDescribe`, `xIt`, etc.)

Those features provide fast testing cycles.

And more, shellspec implements parallel execution. It may increase speed running
tests depending on your tests and the testing hardware.

For those who care about the order of test execution,
It is also possible to run in random order.

Those features are available in all POSIX compliant shells.
Implemented by using shell script and few basic POSIX compliant command only. (really!)
Because there are few external command calls, It is fast and portable.

### 6. Modern reporting

shellspec has modern reporting. When a spec fails, it can be reported in various formats.

#### progress formatter (default)

<script src="https://asciinema.org/a/255960.js" id="asciicast-255960" async data-cols="100" data-rows="24" data-autoplay="true"></script>

#### documentation formatter

<script src="https://asciinema.org/a/255961.js" id="asciicast-255961" async data-cols="100" data-rows="37" data-autoplay="true"></script>

#### TAP formatter

<script src="https://asciinema.org/a/255962.js" id="asciicast-255962" async data-cols="100" data-rows="12" data-autoplay="true"></script>

#### JUnit XML formatter

<script src="https://asciinema.org/a/255963.js" id="asciicast-255963" async data-cols="100" data-rows="22" data-autoplay="true"></script>

### 7. Coverage and profiler

shellspec integrated with [kcov](http://simonkagstrom.github.io/kcov/index.html) for easy to coverage.

<script src="https://asciinema.org/a/256357.js" id="asciicast-256357" async data-cols="100" data-rows="17" data-autoplay="true"></script>

This is [coverage report](https://circleci.com/api/v1.1/project/github/shellspec/shellspec/latest/artifacts/0/root/shellspec/coverage/index.html) of shellspec.
Also, kcov can be integrate with [Coveralls](https://coveralls.io/github/shellspec/shellspec), [Codecov](https://codecov.io/gh/shellspec/shellspec) and etc.

### 8. And what you need

Besides, shellspec has the necessary features for unit testing.

* `Before` / `After` hooks for preparation and cleaning up.
* `Skip` to skip example / `Pending` to indicate the to be implementation.
* `Data` helper that easy to input from stdin.
* `%text` directive that easier to use than heredoc at indented code.
* `%puts` (`%=`) / `%putsn` (`%=`) directive that can be used in place of non-portable `echo`.
* Built-in simple task runner

shellspec is designed with an extensible architecture, so you can create
custom matcher, custom modifier and so on.

shellspec is a powerful but simple to use. Let's enjoy test with [shellspec](https://github.com/shellspec/shellspec)!
