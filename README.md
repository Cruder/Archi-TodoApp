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
crystal build src/todo.cr
```

## Usage

- Execute
```shell
$ ./todo -i
```
You'll enter an interractive mode and be guided to manage your todo list.

But you can also execute simple actions in command lines:
- Add a todo
```shell
$ ./todo -a "My homework"
```

- Display your todo list
```shell
$ ./todo -l
#3 - [2d] Read a book
#4 - [12s] My homework
```

- Mark a todo as done. It won't appear anymore
```shell
$ ./todo -d 3
```

- Remove a todo. It won't appear anymore
```shell
$ ./todo -r 4
```

- Help me!
```shell
$ ./todo -h
```

## Contributing

1. Fork it (<https://github.com/your-github-user/Project/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Alexandre Lairan](https://github.com/your-github-user) - creator and maintainer
- [Célia Casagrande](https://github.com/csgrdcelia) - creator and maintainer
- [Florian Thery](https://github.com/Barogthor) - creator and maintainer
- [Maxime Trembley](https://github.com/brumax) - creator and maintainer
- [Amélie Certin](https://github.com/amelie-certin) - creator and maintainer
