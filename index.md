---
layout: default
title: shellspec
---
# Let's test the your shell script!

[shellspec](https://github.com/shellspec/shellspec) is a BDD style unit testing framework for POSIX compliant shell script

## Get started!

<script src="https://asciinema.org/a/255964.js" id="asciicast-255964" async data-autoplay="true" data-cols="100" data-rows="25"></script>

## Features

* Support POSIX compliant shell (dash, bash, ksh, busybox, etc...)
* BDD style specfile syntax
* The specfile is compatible with shell script syntax
* Implemented by shell script
* Minimal dependencies (use only a few basic POSIX compliant command)
* Nestable block with scope like lexical scope
* Mocking and stubbing (temporary function override)
* Parallel execution, random ordering execution
* Filtering (line number, id, focus, tag and example name)
* The hook before and after of the examples
* Skip and pending of the examples
* Useful and portability standard input / output directive for testing
* Modern reporting (colorize, failure line number)
* Coverage ([kcov](http://simonkagstrom.github.io/kcov/index.html) integration, requires kcov and bash)
* Built-in simple task runner
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

### 1. Comparison with other unit testing frameworks.

|                        | shellspec      | shunit2        | bats-core             |
| ---------------------- | -------------- | -------------- | --------------------- |
| Supported shells       | POSIX shell    | POSIX shell    | bash only             |
| Framework style        | BDD            | xUnit          | original              |
| Spec/test syntax       | shell script   | shell script   | original              |
| Nested block           | support        | -              | -                     |
| Skip / Pending         | both           | skip only      | skip only             |
| Mock / Stub            | built-in       | -              | -                     |
| Assertion line number  | all shells     | limited shells | bash only             |
| Parallel execution     | native support | -              | requires GNU parallel |
| Random execution       | native support | -              | -                     |
| Execute by name        | support        | support        | support               |
| Execute by line number | support        | -              | -                     |
| TAP formatter          | built-in       | -              | built-in              |
| JUnit XML formatter    | built-in       | -              | -                     |
| Coverage               | integration    | manual         | manual                |

### 2. It's a BDD style

shellspec is a BDD style unit testing framework. You can write specifications with
DSL that nearly to natural language. And also those DSL are structured and executable.

shellspec is created inspired by rspec, and it has a DSL suitable for shell scripts.
And it's a readability even if you are not familiar with shell scripts syntax.

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

### 2. Fast testing

If failed your tests, display error with the line number. You can re-run the
failed tests with the line number.

If you want to run specific test only, you can use `--focus` option to run
focused tests. (To focus, prepend 'f' to groups / examples in specfiles.
e.g. `Describe` -> `fDescribe`, `It` -> `fIt`, etc.)

If you want to temporarily skip some tests, prepend 'x' to groups / examples in
specfiles (like `xDescribe`, `xIt`, etc.)

And more, using parallel execution may increase speed running tests depending on
your tests and the testing hardware. (but in my opinion it's fast enough without
parallel execution.)

Those feature are implemented only by shell script, so you can use it all shells.
(Do not requires [$LINENO](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_05_03) variable and [GNU parallel](https://www.gnu.org/software/parallel/))

### 3. Modern reporting

shellspec has modern reporting similar like rspec. When specs fails, it reports
expected and actual with line number and colored.

shellspec has three reporting formatter, `progress`, `documentation`, `tap`, `junit`.

<details>
<summary>progress formatter (default)</summary>
<script src="https://asciinema.org/a/255960.js" id="asciicast-255960" async data-cols="100" data-rows="24" data-autoplay="true"></script>
</details>

<details>
<summary>documentation formatter</summary>
<script src="https://asciinema.org/a/255961.js" id="asciicast-255961" async data-cols="100" data-rows="37" data-autoplay="true"></script>
</details>

<details>
<summary>TAP formatter</summary>
<script src="https://asciinema.org/a/255962.js" id="asciicast-255962" async data-cols="100" data-rows="12" data-autoplay="true"></script>
</details>

<details>
<summary>JUnit XML formatter</summary>
<script src="https://asciinema.org/a/255963.js" id="asciicast-255963" async data-cols="100" data-rows="22" data-autoplay="true"></script>
</details>

### 4. Implements by pure POSIX compliant shell scripts

shellspec is implements by 100% pure POSIX compliant shell scripts.
The required external commands are basic few POSIX compliant commands only.

Not only bash, it supports dash, zsh, ksh, yash, posh and busybox ash. shellspec
is written by POSIX compatible syntax, but you can use extended syntax of bash, etc.

It works on Linux (e.g Debian, Alpine Linux on Docker, OpenWrt), macOS,
Unix (e.g. Solaris) and Windows Subsystem for Linux. Works in more environments.

### 5. The specfile is compatible with shell script syntax

The specfile looks like natural language, but also compatible with shell script
syntax. therefore you can mixing shell script code in specfile and also checking
syntax using by `sh -n`, `shellcheck` and so on.

The specfile is valid shell script syntax, but it extended. It supports nestable
block, scope and temporary function redefinition for mock/stub.

Those features is realized by code translation. The block of DSL translate to
subshell, it executes in own environment. This achieves isolation of tests.

### 6. Coverage

shellspec integrated with kcov for easy to coverage.

<script src="https://asciinema.org/a/255965.js" id="asciicast-255965" async data-cols="100" data-rows="12" data-autoplay="true"></script>

This is [coverage report](https://circleci.com/api/v1.1/project/github/shellspec/shellspec/latest/artifacts/0/root/shellspec/coverage/index.html) of shellspec. Also, kcov can be integrate with [Coveralls](https://coveralls.io/github/shellspec/shellspec), [Codecov](https://codecov.io/gh/shellspec/shellspec) and etc.

### 7. And what you need

Besides, shellspec has the necessary features for unit testing.

* `Before` / `After` hooks for preparation and cleaning up.
* `Pending` to indicate the to be implementation.
* `Data` helper that easy to input from stdin.
* `%text` directive that easier to use than heredoc at indented code.
* `%puts` (`%=`) / `%putsn` (`%=`) directive that can be used in place of non-portable `echo`.
* Built-in simple task runner

shellspec is designed with an extensible architecture, so you can create
custom matcher, custom modifier and so on.

shellspec is a powerful but simple to use. Let's enjoy test with [shellspec](https://github.com/shellspec/shellspec)!
