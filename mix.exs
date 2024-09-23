defmodule EctoEnumMigration.MixProject do
  use Mix.Project

  @name "EctoEnumMigration"
  @version "0.3.6"
  @repo_url "https://github.com/Finbits/ecto_enum_migration"

  def project do
    [
      app: :ecto_enum_migration,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Provides a DSL to easily handle Postgres Enum Types in Ecto database migrations",
      package: package(),
      name: @name,
      source_url: @repo_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @repo_url,
        "Changelog" => "https://hexdocs.pm/ecto_enum_migration/changelog.html"
      }
    ]
  end

  defp docs do
    [
      main: @name,
      source_url: @repo_url,
      source_ref: "v#{@version}",
      extras: [
        "CHANGELOG.md"
      ]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
