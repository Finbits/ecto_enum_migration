defmodule EctoEnumMigration do
  @moduledoc """
  Documentation for EctoEnumMigration.
  """

  @doc """
  create type
  """
  def create_type(name, values, opts \\ [])
      when is_atom(name) and is_list(values) and is_list(opts) do
    type_name = type_name(name, opts)
    type_values = values |> Enum.map(fn value -> "'#{value}'" end) |> Enum.join(", ")

    create_sql = "CREATE TYPE #{type_name} AS ENUM (#{type_values});"
    drop_sql = "DROP TYPE #{type_name};"

    Ecto.Migration.execute(create_sql, drop_sql)
  end

  def drop_type(name, opts \\ []) when is_atom(name) and is_list(opts) do
    type_name = type_name(name, opts)
    drop_sql = "DROP TYPE #{type_name};"

    Ecto.Migration.execute(drop_sql)
  end

  def rename_type(before_name, after_name, opts \\ [])
      when is_atom(before_name) and is_atom(after_name) and is_list(opts) do
    before_type_name = type_name(before_name, opts)
    after_type_name = type_name(after_name, opts)

    up_sql = "ALTER TYPE #{before_type_name} RENAME TO #{after_name};"
    down_sql = "ALTER TYPE #{after_type_name} RENAME TO #{before_name};"

    Ecto.Migration.execute(up_sql, down_sql)
  end

  defp type_name(name, opts) do
    schema = Keyword.get(opts, :schema, "public")
    "#{schema}.#{name}"
  end
end
