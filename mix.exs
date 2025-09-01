defmodule Nomify.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      aliases: aliases(),
      listeners: [Phoenix.CodeReloader],
      preferred_cli_env: [
        "test.watch": :test
      ],
      # Docs
      name: "Nomify",
      source_url: "https://github.com/nicholasjhenry/nomify-next",
      docs: &docs/0
    ]
  end

  defp docs do
    [
      main: "Nomify",
      # logo: "path/to/logo.png",
      formatters: ["html"],
      ignore_apps: [:nomify_web],
      main: "readme",
      extras: [
        "README.md",
        "notebooks/case_study_1.livemd",
        "notebooks/case_study_2.livemd"
      ],
      groups_for_extras: [
        Guides: Path.wildcard("guides/*.md"),
        "Case Studies": Path.wildcard("notebooks/*.livemd")
      ],
      assets: %{
        "guides/assets" => "assets"
      },
      api_reference: true,
      groups_for_modules: [
        Accounts: [
          ~r"^Nomify\.Accounts",
          ~r"^Nomify\.Accounts\..*"
        ],
        Directory: [
          ~r"^Nomify\.Directory",
          ~r"^Nomify\.Directory\..*"
        ],
        Teams: [
          ~r"^Nomify\.Teams",
          ~r"^Nomify\.Teams\..*"
        ],
        Documents: [
          ~r"^Nomify\.Documents",
          ~r"^Nomify\.Documents\..*"
        ],
        Util: [
          ~r"^Nomify\.Util",
          ~r"^Nomify\.Util\..*"
        ]
      ],
      nest_modules_by_prefix: []
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    [
      {:igniter, "~> 0.5", only: [:dev, :test]},
      {:phoenix, "~> 1.8.0-rc.0", override: true},
      # Required to run "mix format" on ~H/.heex files from the umbrella root
      {:phoenix_live_view, ">= 0.0.0"},
      # Application dependencies
      {:ecto_erd, "~> 0.6.4", only: [:dev]},
      {:ex_doc, "~> 0.38.1", only: [:dev]},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"],
      "usage_rules.sync": [
        "do --app nomify_web cmd mix usage_rules.sync ../../AGENTS.md --all --inline usage_rules:all  --link-to-folder deps"
      ],
      docs: ["docs", "docs.gen.erd"],
      "docs.gen.erd": [
        "cmd mkdir -p doc/assets",
        # NOTE: See `./.ecto_erd.exs for configuration`
        "ecto.gen.erd --output-path doc/assets/ecto_erd.dot",
        # process in the root of the umbrella (../../)
        "cmd dot -Tpng ../../doc/assets/ecto_erd.dot -o ../../doc/assets/erd.png"
      ]
    ]
  end
end
