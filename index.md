---
layout: default
title: ShellSpec
---
# Let's test the your shell script!

[ShellSpec][shellspec] is the most featureful BDD unit testing framework for dash, bash, ksh, zsh and **all POSIX shells** that
**provides first-class features** such as [coverage report][coverage], parallel execution, parameterized testing and more.
It was developed as a development / test tool for **developing cross-platform shell scripts and shell script libraries**.
It has been implemented in POSIX compliant shell script and minimal dependencies.
Therefore, it works not only on PC but also in restricted environments such as a minimal Docker image and embedded system.

[shellspec]: https://github.com/shellspec/shellspec

## Get started!

<div style="height: 30em;margin-left:30px">
<script src="https://asciinema.org/a/256723.js" id="asciicast-256723" async data-autoplay="true" data-cols="120" data-rows="25"></script>
</div>

Try the **[Online Demo](demo)** on the browser.

## Table of Contents <!-- omit in toc -->

- [Get started!](#get-started)
- [Why use ShellSpec?](#why-use-shellspec)
  - [1. Comparison with other testing frameworks](#1-comparison-with-other-testing-frameworks)
  - [2. It's a BDD style](#2-its-a-bdd-style)
  - [3. Support nestable block with scope](#3-support-nestable-block-with-scope)
  - [4. Parameterized tests](#4-parameterized-tests)
  - [5. Fast testing and high portability](#5-fast-testing-and-high-portability)
  - [6. Modern reporting](#6-modern-reporting)
  - [7. Coverage and profiler](#7-coverage-and-profiler)
  - [8. And what you need](#8-and-what-you-need)

## Why use ShellSpec?

### 1. Comparison with other testing frameworks

|                           | ShellSpec                     | shUnit2                   | Bats-core                       |
| ------------------------- | ----------------------------- | ------------------------- | ------------------------------- |
| Supported shells          | all POSIX shell               | Bourne shell, POSIX shell | bash only                       |
| Framework style           | BDD                           | xUnit                     | original                        |
| Spec / test syntax        | DSL (shell script compatible) | shell script              | original (almost bash)          |
| Nestable block with scope | support                       | -                         | -                               |
| Before / After hooks      | support                       | support                   | support                         |
| Skip / Pending / Focus    | support (all)                 | support (skip only)       | support (skip only)             |
| Mock / Stub               | support (built-in)            | -                         | - (extension exists)            |
| Parameterized tests       | support                       | -                         | -                               |
| Assertion line number     | support (all shells)          | support (limited shells)  | support (bash only)             |
| Quick execution           | support                       | -                         | -                               |
| Parallel execution        | support                       | -                         | support (requires GNU parallel) |
| Random execution          | support                       | -                         | -                               |
| Filtering by name         | support                       | support                   | support                         |
| Filtering by line number  | support                       | -                         | -                               |
| TAP formatter             | support                       | -                         | support                         |
| JUnit XML formatter       | support                       | -                         | -                               |
| Coverage                  | support (requires kcov)       | -                         | -                               |
| Profiler                  | support                       | -                         | -                               |
| Cyclomatic Complexity     | [ShellMetrics][]              | -                         | -                               |

- Quick execution: Run only non-passed examples the last time they ran

[ShellMetrics]:https://github.com/shellspec/shellmetrics

#### Other comparison <!-- omit in toc -->

- [Bash test framework comparison 2020](https://github.com/dodie/testing-in-bash)

### 2. It's a BDD style

ShellSpec is a BDD style unit testing framework. You can write specifications with
DSL that nearly to natural language. And also those DSL are structured and executable.

ShellSpec is created inspired by RSpec, and it has a DSL suitable for shell scripts.
And it's a readability even if you are not familiar with shell scripts syntax.

#### Specfile syntax <!-- omit in toc -->

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

#### Comparison with Bats-core <!-- omit in toc -->

- [Bats-core: Bash Automated Testing System (2018)](https://github.com/bats-core/bats-core)

ShellSpec is less syntax of shell scripts specific, and you can write
specification in sentences nearly to natural language.

##### Bats-core <!-- omit in toc -->

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

##### ShellSpec <!-- omit in toc -->

```sh
#shellcheck shell=sh

Example "addition using bc"
  Data "2+2"
  When call bc
  The output should eq 4
End

Example "addition using dc"
  Data "2 2+p"
  When call dc
  The output should eq 4
End
```

#### Comparison with shunit2 <!-- omit in toc -->

[shUnit2 is a xUnit based unit test framework for Bourne based shell scripts.](https://github.com/kward/shunit2)

ShellSpec has structured DSL and readability.

##### shUnit2 <!-- omit in toc -->

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

##### ShellSpec <!-- omit in toc -->

```sh
#shellcheck shell=sh

Include ./math.inc

Describe 'Adding'
  It 'adds values'
    When call add_generic 1 2
    The output should eq 3
  End

  Skip if 'non-generic tests' [ -z "${BASH_VERSION:-}" ]

  It 'adds values'
    When call add_bash 1 2
    The output should eq 3
  End
End
```

### 3. Support nestable block with scope

ShellSpec supports nested block structure. It realize local variables and
functions that can only be used within a block.

#### Easy to mock / stub <!-- omit in toc -->

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
You can easily rerun only failed tests using Quick execution.
You can also rerun using the line number or spec description.

<script src="https://asciinema.org/a/256058.js" id="asciicast-256058" async data-cols="100" data-rows="24"></script>

If you want to run specific test only, you can use `--focus` option to run
focused tests. (To focus, prepend 'f' to groups / examples in specfiles.
e.g. `Describe` -> `fDescribe`, `It` -> `fIt`, etc.)

If you want to temporarily skip some tests, prepend 'x' to groups / examples in
specfiles (like `xDescribe`, `xIt`, etc.)

Those features provide fast testing cycles.

And more, ShellSpec implements parallel execution. It may increase speed running
tests depending on your tests and the testing hardware.

For those who care about the order of test execution,
It is also possible to run in random order.

Those features are available in all POSIX compliant shells.
Implemented by using shell script and few basic POSIX compliant command only. (really!)
Because there are few external command calls, It is fast and portable.

### 6. Modern reporting

ShellSpec has modern reporting. When a spec fails, it can be reported in various formats.

#### progress formatter (default) <!-- omit in toc -->

<script src="https://asciinema.org/a/255960.js" id="asciicast-255960" async data-cols="100" data-rows="24" data-autoplay="true"></script>

#### documentation formatter <!-- omit in toc -->

<script src="https://asciinema.org/a/255961.js" id="asciicast-255961" async data-cols="100" data-rows="37" data-autoplay="true"></script>

#### TAP formatter <!-- omit in toc -->

<script src="https://asciinema.org/a/255962.js" id="asciicast-255962" async data-cols="100" data-rows="12" data-autoplay="true"></script>

#### JUnit XML formatter <!-- omit in toc -->

<script src="https://asciinema.org/a/255963.js" id="asciicast-255963" async data-cols="100" data-rows="22" data-autoplay="true"></script>

### 7. Coverage and profiler

ShellSpec integrated with [kcov](http://simonkagstrom.github.io/kcov/index.html) for easy to coverage.

<script src="https://asciinema.org/a/256357.js" id="asciicast-256357" async data-cols="100" data-rows="17" data-autoplay="true"></script>

This is [coverage report][coverage] of ShellSpec. Also, kcov can be integrate with [Coveralls][coveralls], [Codecov][codecov] and etc.

[coverage]: https://circleci.com/api/v1.1/project/github/shellspec/shellspec/latest/artifacts/0/coverage/index.html
[coveralls]: https://coveralls.io/github/shellspec/shellspec
[codecov]: https://codecov.io/gh/shellspec/shellspec

Note: Coverage support is bash, ksh, zsh only.

### 8. And what you need

Besides, ShellSpec has the necessary features for unit testing.

- `Before`/`After` and `BeforeAll`/`AfterAll` hooks for preparation and cleaning up.
- `Skip` to skip example / `Pending` to indicate the to be implementation.
- `Data` helper that easy to input from stdin.
- `%text` directive that easier to use than heredoc at indented code.
- `%puts` (`%=`) / `%putsn` (`%=`) directive that can be used in place of non-portable `echo`.
- Built-in simple task runner

ShellSpec is designed with an extensible architecture, so you can create
custom matcher, custom modifier and so on.

ShellSpec is a powerful but simple to use. Let's enjoy test with [shellspec](https://github.com/shellspec/shellspec)!
