# Project

Manage your time, plan your todo-list with your shell.

## Installation

### Requirements
- First you need to install [crystal](https://crystal-lang.org/install/)
- And also [sqlite](https://www.servermania.com/kb/articles/install-sqlite/)

### Setup
```shell
shards install
shards build
./bin/micrate up
```

## Usage

- Execute
```shell
$ ./bin/todo -i
```
You'll enter an interractive mode and be guided to manage your todo list.

But you can also execute simple actions in command lines:
- Add a todo
```shell
$ ./bin/todo -a "My homework"
```

- Display your todo list
```shell
$ ./bin/todo -l
#3 - [2d] Read a book
#4 - [12s] My homework
```

- Mark a todo as done. It won't appear anymore
```shell
$ ./bin/todo -d 3
```

- Remove a todo. It won't appear anymore
```shell
$ ./bin/todo -r 4
```

- Help me!
```shell
$ ./bin/todo -h
```

## Contributors

- [Alexandre Lairan](https://github.com/alex-lairan) - creator and maintainer
- [Célia Casagrande](https://github.com/csgrdcelia) - creator and maintainer
- [Florian Thery](https://github.com/Barogthor) - creator and maintainer
- [Maxime Trembley](https://github.com/brumax) - creator and maintainer
- [Amélie Certin](https://github.com/amelie-certin) - creator and maintainer
