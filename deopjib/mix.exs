defmodule Deopjib.MixProject do
  use Mix.Project
  @assets_path Path.expand("./assets", __DIR__)

  def project do
    [
      app: :deopjib,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Deopjib.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe_phoenix, "~> 2.0"},
      {:ash_graphql, "~> 1.0"},
      {:ex_cldr, "~> 2.40"},
      {:ex_cldr_numbers, "~> 2.33"},
      {:oban, "~> 2.0"},
      {:puid, "~> 2.3"},
      {:oban_web, "~> 2.11"},
      {:ash_state_machine, "~> 0.2"},
      {:ash_oban, "~> 0.3"},
      {:ash_admin, "~> 0.13"},
      {:live_state, "~> 0.8.2"},
      {:ash_authentication_phoenix, "~> 2.0"},
      {:picosat_elixir, "~> 0.2.3"},
      {:ash_authentication, "~> 4.0"},
      {:ash_postgres, "~> 2.0"},
      {:ash_phoenix, "~> 2.0"},
      {:sourceror, "~> 1.8", only: [:dev, :test]},
      {:ash, "~> 3.0"},
      {:igniter, "~> 0.5", only: [:dev, :test]},
      {:phoenix, "~> 1.7.20"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0"},
      {:live_debugger, "~> 0.1.0", only: :dev},
      {:floki, ">= 0.37.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:dns_cluster, "~> 0.2"},
      {:bandit, "~> 1.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ash.setup", "assets.setup", "run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": ["cmd bun install --only-missing"],
      "assets.deploy": [
        "cmd --cd #{@assets_path} bun js --deploy",
        "cmd --cd #{@assets_path} bun tailwind --minify",
        "phx.digest"
      ],
      "phx.routes": ["phx.routes", "ash_authentication.phoenix.routes"]
    ]
  end
end
