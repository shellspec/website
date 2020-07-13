---
layout: default
title: Why am I developing ShellSpec?
---

# Why am I developing ShellSpec?

What I wanted is a dev/test tool for developing cross-platform shell scripts and shell script libraries. As a testing framework, I place importance on being able to write highly reliable tests with high readability. I also didn't want to compromise on features just because it was a shell script. The goal is a shell script version of [RSpec](https://rspec.info/).

The shell script has two well-known testing frameworks, shUnit2 and Bats-core, and many other testing frameworks. However, they were not very actively developed and their reliability and features did not reach the standards I wanted.

ShellSpec's first goal was to support nestable blocks with scoped. I had an idea to realize it, but it needed a design that was radically different from other frameworks.

## Reason for developing with shell script

Many people say that you should use a true programming language instead of shell scripts. I think it's a make sense, but it doesn't mean there's no reason to develop it in a shell script. For example, shell scripts are the only way to work in many environments that do not require a build and do not have a scripting runtime installed.

You're probably working in a terminal using a shell such as bash or zsh rather than a programming language. Clearly, shell scripts are better suited for some problem. Shell scripts are the best choice for processing by cooperate with commands. It will be easier to use if there is a shell scripts that supports cooperate with commands. Please decide the tool to use according to the purpose. [It is wrong to decide the tool by the number of code lines](https://google.github.io/styleguide/shellguide.html#when-to-use-shell).

It's true that development using shell scripts is difficult, but the reason is not the syntax. This is because there are not enough shell script libraries.
It is similar to early JavaScript.

A test framework is required to create a shell script library. ShellSpec solves the problem that shell scripts are difficult to test. And by increasing the number of shell script libraries facilitates development using shell scripts.

## About other test frameworks

### shUnit2

[shUnit2](https://github.com/kward/shunit2) is a xUnit based testing framework for supports many POSIX shells. However, the number of features is small and some features may not be available in all shells. For example, the line number display when an error occurs depends on the `LINENO` variable of the shell and not available in my favorite shell, dash on debian. Even available shells, You must use the macro `${_ASSERT_EQUALS_}`, which makes the test code difficult to read. Also, zsh requires that `setopt shwordsplit` be enabled, which makes it difficult to write tests in a single code.

shUnit2 claims to support many shells, but for a long time it hasn't been properly tested in any shell other than bash and current shUnit2 itself tests are broken ([#121](https://github.com/kward/shunit2/issues/121), [#130](https://github.com/kward/shunit2/pull/130)). It may work, but I can't say reliable test framework unfortunately.

There is no assertion for stdout and you need to write [helper functions](https://github.com/kward/shflags/blob/master/shflags_test_helpers) to use practically, so you need shell script knowledge and [undocumented testing techniques](https://github.com/kward/shflags/blob/master/shflags_parsing_test.sh).

Also, since there is no isolation between tests as a basic design, it is susceptible to other tests. Tests are shell scripts, so you can handle them yourself, but it can be a difficult task.

### Bats-core

[Bats-core](https://github.com/bats-core/bats-core) is probably the most used framework in shell scripts. It has more features than shunit2. (However, it is not so much compared to ShellSpec).

This is an acceptable testing framework, but there are some issues I'm concerned about.

- [Separate stdout and stderr from the run output](https://github.com/bats-core/bats-core/pull/2)
- [Fix globbing issue in run command](https://github.com/bats-core/bats-core/pull/152)
- [Don't glob output](https://github.com/bats-core/bats-core/pull/158)
- [Fix the implementation of the run helper function to properly parse lines of output](https://github.com/bats-core/bats-core/pull/289)
- [Isolated temp dir per run](https://github.com/bats-core/bats-core/issues/283)

There are many other minor issues, but the big drawback for me is that it only supports bash. It couldn't be my option because.

Bats is not suitable for testing shell functions in my opinion. For example, the following example cannot test variables.

```sh
foo() {
  echo foo
  printf -v "$1" 123
}

@test "foo" {
  run foo ret
  [ "$output" == 'foo' ]
  [ "$ret" == 123 ] # will be failure
}
```

ShellSpec is a unit testing framework and the main focus of testing is on shell functions rather than external commands. The method of returning results to a variable is a fast method that does not require a subshell. The difficulty of this test is a major drawback as unit testing.

### shpec

[shpec](https://github.com/rylnd/shpec) is not so famous as shUnit2 or Bats-core, but it supports a lot of shells and seems to be relatively used as a BDD-style testing framework.

It looks like there are nestable blocks similar to ShellSpec, However, it is only used for display grouping and does not provide isolation for each test. Therefore, the state of the test execution result easily affects other tests.

It also lacks many features such as skipping tests and Before/After hooks.

## ShellSpec

ShellSpec not only solves the problems of other testing frameworks, but also provides many more useful features. Quick execution and parallel execution speed up the test cycle during development, and the xtrace function that can trace only the important part helps debugging. In addition, kcov integration allows you to generate coverage reports with minimal configuration.

### DSL

Some people think that DSL is advantageous, others think it is not. ShellSpec is a BDD testing framework and adopts a DSL that is close to natural language. One of my reasons was my preference, but as I continued to develop, using a DSL proved to be the right decision.

Shell scripts have many traps, especially for beginners. For example, a command substitution that stores the output of a command in a variable will remove the trailing newline.

```sh
result=$(printf 'test\n\n\n\n')
echo "[$result]" # => [test]
```

In the following example, the exit status is ignored.

```sh
local result=$(echo "error" >&2; exit 1)
echo $? # => 0
```

By using a DSL, you can avoid these traps, which beginners often fall into, and determine the validity of your test without having to be familiar with shell scripts.

The DSL also implements a lot of workarounds to avoid certain shell bugs. It also accommodates differences in behavior between shells, so a single test code can support multiple shells. Developers can concentrate on essential tests without being bothered by shell differences.

There are various other useful DSLs such as mocking and parameterized test, But the most important is the nestable block with scopes. This block is the basis of all DSLs and allows you to simply write structured tests.
