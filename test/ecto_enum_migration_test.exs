defmodule EctoEnumMigrationTest do
  use ExUnit.Case
  import Ecto.Query
  alias EctoEnumMigration.TestRepo

  @moduletag :capture_log

  defmodule CreateTypeMigration do
    use Ecto.Migration
    import EctoEnumMigration

    def change do
      create_type(:status, [:registered, :active, :inactive, :archived])
    end
  end

  defmodule CreateSchemaMigration do
    use Ecto.Migration

    def change do
      execute("CREATE SCHEMA IF NOT EXISTS custom_schema", "DROP SCHEMA IF EXISTS custom_schema")
    end
  end

  defmodule CreateTypeWithCustomSchemaMigration do
    use Ecto.Migration
    import EctoEnumMigration

    def change do
      create_type(:status, [:registered, :active, :inactive, :archived], schema: "custom_schema")
    end
  end

  defmodule DropTypeMigration do
    use Ecto.Migration
    import EctoEnumMigration

    def change do
      drop_type(:status)
    end
  end

  defmodule DropTypeWithCustomSchemaMigration do
    use Ecto.Migration
    import EctoEnumMigration

    def change do
      drop_type(:status, schema: "custom_schema")
    end
  end

  defmodule RenameTypeMigration do
    use Ecto.Migration
    import EctoEnumMigration

    def change do
      rename_type(:status, :status_renamed)
    end
  end

  defmodule RenameTypeWithCustomSchemaMigration do
    use Ecto.Migration
    import EctoEnumMigration

    def change do
      rename_type(:status, :status_renamed, schema: "custom_schema")
    end
  end

  setup do
    :ok = Ecto.Adapters.Postgres.storage_down(TestRepo.config())
    :ok = Ecto.Adapters.Postgres.storage_up(TestRepo.config())
    {:ok, _pid} = TestRepo.start_link()

    :ok
  end

  describe "create_type/3" do
    test "creates and drops type" do
      num = version_number()

      :ok = up(num, CreateTypeMigration)

      assert current_types() == %{
               "public.status" => ["registered", "active", "inactive", "archived"]
             }

      :ok = down(num, CreateTypeMigration)
    end

    test "supports custom schema" do
      num = version_number()

      :ok = up(version_number(), CreateSchemaMigration)

      :ok = up(num, CreateTypeWithCustomSchemaMigration)

      assert current_types() == %{
               "custom_schema.status" => ["registered", "active", "inactive", "archived"]
             }

      :ok = down(num, CreateTypeWithCustomSchemaMigration)
    end
  end

  describe "drop_type/2" do
    test "drops type" do
      :ok = up(version_number(), CreateTypeMigration)

      num = version_number()
      :ok = up(num, DropTypeMigration)

      assert current_types() == %{}

      assert_raise Ecto.MigrationError, ~r/cannot reverse migration command/, fn ->
        :ok = down(num, DropTypeMigration)
      end
    end

    test "supports custom schema" do
      :ok = up(version_number(), CreateSchemaMigration)
      :ok = up(version_number(), CreateTypeWithCustomSchemaMigration)

      num = version_number()
      :ok = up(num, DropTypeWithCustomSchemaMigration)

      assert current_types() == %{}

      assert_raise Ecto.MigrationError, ~r/cannot reverse migration command/, fn ->
        :ok = down(num, DropTypeWithCustomSchemaMigration)
      end
    end
  end

  describe "rename_type/3" do
    test "renames type" do
      create_version = version_number()
      rename_version = version_number()

      :ok = up(create_version, CreateTypeMigration)
      assert Map.keys(current_types()) == ["public.status"]

      :ok = up(rename_version, RenameTypeMigration)
      assert Map.keys(current_types()) == ["public.status_renamed"]

      :ok = down(rename_version, RenameTypeMigration)
      assert Map.keys(current_types()) == ["public.status"]

      :ok = down(create_version, CreateTypeMigration)
    end

    test "supports custom schema" do
      create_version = version_number()
      rename_version = version_number()

      :ok = up(version_number(), CreateSchemaMigration)

      :ok = up(create_version, CreateTypeWithCustomSchemaMigration)
      assert Map.keys(current_types()) == ["custom_schema.status"]

      :ok = up(rename_version, RenameTypeWithCustomSchemaMigration)
      assert Map.keys(current_types()) == ["custom_schema.status_renamed"]

      :ok = down(rename_version, RenameTypeWithCustomSchemaMigration)
      assert Map.keys(current_types()) == ["custom_schema.status"]

      :ok = down(create_version, CreateTypeWithCustomSchemaMigration)
    end
  end

  defp up(version, migration) do
    Ecto.Migrator.up(TestRepo, version, migration, log: false)
  end

  defp down(version, migration) do
    Ecto.Migrator.down(TestRepo, version, migration, log: false)
  end

  defp current_types do
    from(
      t in "pg_type",
      join: e in "pg_enum",
      on: e.enumtypid == t.oid,
      join: n in "pg_namespace",
      prefix: "pg_catalog",
      on: n.oid == t.typnamespace,
      select: %{schema: fragment("CONCAT(?, '.', ?)", n.nspname, t.typname), value: e.enumlabel}
    )
    |> TestRepo.all(log: false)
    |> Enum.group_by(&Map.get(&1, :schema), &Map.get(&1, :value))
  end

  defp version_number do
    System.unique_integer([:positive, :monotonic]) + 1_000_000
  end
end
