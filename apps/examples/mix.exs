defmodule Examples.MixProject do
  use Mix.Project

  def project do
    [
      app: :examples,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # Docs
      name: "Examples",
      homepage_url: "../index.html",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Examples.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:pg_ranges, "~> 1.1.1"},
      {:essential_ecto, in_umbrella: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp docs do
    [
      # NOTE: Module name
      main: "Examples",
      output: "../../doc/examples",
      groups_for_modules: [
        Accounts: [
          ~r"^Examples\.ComputerStore",
          ~r"^Examples\.ComputerStore\..*"
        ],
        "Distribution Center": [
          ~r"^Examples\.DistributionCenter",
          ~r"^Examples\.DistributionCenter\..*"
        ],
        "Luxury Catalog": [
          ~r"^Examples\.LuxuryCatalog",
          ~r"^Examples\.LuxuryCatalog\..*"
        ],
        "Office Supply Store": [
          ~r"^Examples\.OfficeSupplyStore",
          ~r"^Examples\.OfficeSupplyStore\..*"
        ],
        "Public Library": [
          ~r"^Examples\.PublicLibrary",
          ~r"^Examples\.PublicLibrary\..*"
        ],
        Warehouse: [
          ~r"^Examples\.Warehouse",
          ~r"^Examples\.Warehouse\..*"
        ],
        Util: [
          ~r"^Examples\.Util",
          ~r"^Examples\.Util\..*"
        ]
      ]
    ]
  end
end
