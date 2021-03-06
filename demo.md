---
layout: default
title: ShellSpec demo
---

# Online Demo

**Run the following command.**

```sh
# Step 1. Install ShellSpec
. setup.sh

# Step 2. Run Sample tests
shellspec

# Step 3. Run ShellSpec tests
cd ~/.local/lib/shellspec/
shellspec
```

<iframe height="720px" width="100%" src="https://repl.it/@ko1nksm/shellspec-demo?lite=true&outputonly=1" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

Do you want to see or edit the code in a browser? [Open in Repl.it](https://repl.it/@ko1nksm/shellspec-demo).

```
$ tree
.
|-- fizzbuzz.sh
|-- lib
|   `-- array.sh
`-- spec
    |-- fizzbuzz_spec.sh
    |-- array_spec.sh
    |-- system_spec.sh
    `-- spec_helper.sh
```

----

[Demo running on Docker](https://hub.docker.com/r/shellspec/demo) also available.

```sh
# How to run

docker run --rm -it shellspec/demo
```
