# EctoEnumMigration

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_enum_migration` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_enum_migration, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_enum_migration](https://hexdocs.pm/ecto_enum_migration).

```
import EctoEnumMigration

create_type(type, enums, schema: )
drop_type(type, enums, schema: )
rename_type(from: , to: , schema:)

create_type_if_not_exists(type, enums, schema: )
drop_if_exists(type, enums, schema: )
add_value_to_type(type, value, before: , after: , schema: )
```
