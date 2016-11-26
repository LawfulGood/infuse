# Infuse

[![Build Status](https://travis-ci.org/clone1018/infuse.svg?branch=master)](https://travis-ci.org/clone1018/infuse)

Simple filesystem web framework using [Simplates](https://github.com/clone1018/infuse/wiki/Simplates). Inspired by [Aspen](https://github.com/AspenWeb/aspen.py). Using [Plug](https://github.com/elixir-lang/plug)

It is currently **not ready for use in development or production**.


## Possible Installation

You can use [Hex](https://hex.pm/packages/infuse), to install the package:

  1. Add `infuse` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:infuse, "~> 0.1.0"}]
    end
    ```

  2. Ensure `infuse` is started before your application:

    ```elixir
    def application do
      [applications: [:infuse]]
    end
    ```

  3. Figure out what's next, because I have no idea!

## Credits & License
[LICENSE](LICENSE.md)

Entire inspiration and design is from [https://github.com/AspenWeb/aspen.py](https://github.com/AspenWeb/aspen.py) 
