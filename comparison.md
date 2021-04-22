---
layout: default
title: ShellSpec vs shUnit2 vs Bats-core
---

# ShellSpec vs shUnit2 vs Bats-core

## Feature comparison list

|                           | ShellSpec                     | shUnit2                   | Bats-core                       |
| ------------------------- | ----------------------------- | ------------------------- | ------------------------------- |
| Supported shells          | all POSIX shell               | Bourne shell, POSIX shell | bash only                       |
| Framework style           | BDD                           | xUnit                     | original                        |
| Syntax                    | DSL (shell script compatible) | shell script              | almost bash                     |
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
| JUnit XML formatter       | support                       | -                         | support                         |
| Coverage                  | support (requires kcov)       | -                         | -                               |
| Profiler                  | support                       | -                         | -                               |

## Syntax comparison with shUnit2

[shUnit2 is a xUnit based unit test framework for Bourne based shell scripts.](https://github.com/kward/shunit2)

### shUnit2

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

### ShellSpec

```sh
#shellcheck shell=sh

Include ./math.inc

Describe 'add_generic()'
  It 'adds values using expr'
    When call add_generic 1 2
    The output should eq 3
  End
End

Describe 'add_bash()'
  Skip if 'non-generic tests' [ -z "${BASH_VERSION:-}" ]

  It 'adds values using arithmetic expansion'
    When call add_bash 1 2
    The output should eq 3
  End
End
```

## Syntax comparison with Bats-core

- [Bats-core: Bash Automated Testing System (2018)](https://github.com/bats-core/bats-core)

### Bats-core

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

@test "invoking foo with a nonexistent file prints an error" {
  run foo nonexistent_filename
  [ "$status" -eq 1 ]
  [ "$output" = "foo: no such file 'nonexistent_filename'" ]
}

@test "invoking foo without arguments prints usage" {
  run foo
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "usage: foo <filename>" ]
}
```

### ShellSpec

```sh
#shellcheck shell=sh

Example "addition using bc"
  Data "2+2"
  When run bc
  The output should eq 4
End

Example "addition using dc"
  Data "2 2+p"
  When run dc
  The output should eq 4
End

Example "invoking foo with a nonexistent file prints an error"
  When run foo nonexistent_filename
  The status should eq 1
  The output should eq "foo: no such file 'nonexistent_filename'"
End

Example "invoking foo without arguments prints usage"
  When run foo
  The status should eq 1
  The line 1 should eq "usage: foo <filename>"
End
```

## Other comparison resources

- [Bash test framework comparison 2020](https://github.com/dodie/testing-in-bash)
