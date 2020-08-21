defmodule EctoEnumMigration.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_enum_migration,
      version: "0.3.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Provides a DSL to easily handle Postgres Enum Types in Ecto database migrations",
      package: package(),
      name: "EctoEnumMigration",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/brainn-co/ecto_enum_migration"}
    ]
  end

  defp docs do
    [
      main: "EctoEnumMigration",
      source_url: "https://github.com/brainn-co/ecto_enum_migration"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
