defmodule EssentialEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :essential_ecto,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # Docs
      name: "Essential Ecto",
      homepage_url: "../index.html",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:ex_doc, "~> 0.38.1", only: [:dev]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: []
    ]
  end

  defp docs do
    [
      main: "readme",
      output: "../../doc/essential_ecto",
      extras: [
        "README.md",
        "usage-rules/10_essential_ecto.md",
        "usage-rules/20_association_patterns.md",
        "usage-rules/30_association_validations.md",
        "usage-rules/40_fields_and_actions.md",
        "usage-rules/50_implementing_associations.md",
        "usage-rules/60_implementing_business_rules.md"
      ],
      groups_for_extras: [
        "LLM Usage Rules": Path.wildcard("./usage-rules/*.md")
      ]
    ]
  end
end
