# EctoEnumMigration

[![CI](https://github.com/brainn-co/ecto_enum_migration/workflows/CI/badge.svg?branch=master)](https://github.com/brainn-co/ecto_enum_migration/actions)
[![Hex.pm](https://img.shields.io/hexpm/v/ecto_enum_migration)][hex-url]
[![Hex.pm](https://img.shields.io/hexpm/l/ecto_enum_migration)][hex-url]
[![Hex.pm](https://img.shields.io/hexpm/dt/ecto_enum_migration)][hex-url]

Provides a DSL to easily handle Postgres Enum Types in Ecto database migrations.

## Why

[`ecto_enum`](https://github.com/gjaldon/ecto_enum) provides some handy helpers to create and drop types during migration.
The problem with them is that the migrations endedup coupled with the current state
of the code of the enums.

So any change to a existing enum, or even a rename of the module that holds the
migration, has a high chance to break existing migrations. So in order to have a
highly reliable migration suite it need to be fully decoupled from the rest of
the application.

## Installation

The package can be installed by adding `ecto_enum_migration` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_enum_migration, "~> 0.3.1"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/ecto_enum_migration](https://hexdocs.pm/ecto_enum_migration).

## License

[Apache License, Version 2.0](LICENSE) © [brainn.co](https://github.com/brainn-co)

[hex-url]: https://hex.pm/packages/ecto_enum_migration
