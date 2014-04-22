# 1 System Setup

There is no substitute for learning by tinkering. Getting Elixir set up on most platforms is a snap, and we should be quickly on our way.

The only prerequisite for Elixir is Erlang, version R17 or later. Official [precompiled packages](https://www.erlang-solutions.com/downloads/download-erlang-otp)
are available for most platforms.

To check your installed erlang version:

```bash
$ erl
Erlang/OTP 17 [erts-6.0] ...
```

## Mac OSX

Install via [homebrew](http://brew.sh/)

```bash
$ brew update
$ brew install erlang --devel
$ brew install https://github.com/josevalim/homebrew/blob/1cb4fa94c90c3fc931bd07e778ee3ff967b4a48d/Library/Formula/elixir.rb
```


## Linux
Install Elixir with your favorite package manager

### Fedora 17+ and Fedora Rawhide
```bash
$ sudo yum -y install elixir
```

### Arch Linux (on AUR)
```bash
$ yaourt -S elixir
```

### openSUSE (and SLES 11 SP3+)
```bash
$ zypper ar -f obs://devel:languages:erlang/ erlang
$ zypper in elixir
```

### Gentoo
```bash
$ emerge --ask dev-lang/elixir
```

## Windows

Install Erlang (R16B02) from the official [precompiled packages](https://www.erlang-solutions.com/downloads/download-erlang-otp).

Install Elixir through [Chocolatey](http://chocolatey.org/)

```
> cinst elixir
```

## Test your setup

Elixir ships with three executables, `iex`, `elixir`, and `elixirc`.
Fire up `iex` to run the Elixir shell. In iex, or "Iteractive Elixir," we can
execute any valid Elixir expression and see the evaluated result.

```elixir
$ iex
iex(1)> IO.puts "Hello Elixir!"
Hello Elixir!
:ok
iex(2)>
```


Now you have everything you need to get started programming Elixir.
