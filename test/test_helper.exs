defmodule EctoEnumMigration.TestRepo do
  use Ecto.Repo,
    otp_app: :ecto_enum_migration,
    adapter: Ecto.Adapters.Postgres
end

Application.put_env(:ecto_enum_migration, EctoEnumMigration.TestRepo,
  url: System.get_env("POSTGRES_URL", "postgres://postgres:postgres@localhost:5432/ecto_enum_migration_test"),
  pool: Ecto.Adapters.SQL.Sandbox
)

ExUnit.start()
