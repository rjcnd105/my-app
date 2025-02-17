# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :dutchpay, Dutchpay.Mailer, adapter: Swoosh.Adapters.Local

# Configure Mix tasks and generators
config :dutchpay,
  ecto_repos: [Dutchpay.Repo]

# Configures the endpoint
config :dutchpay_web, DutchpayWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DutchpayWeb.ErrorHTML, json: DutchpayWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Dutchpay.PubSub,
  live_view: [signing_salt: "g9CW4eyU"]

config :dutchpay_web,
  ecto_repos: [Dutchpay.Repo],
  generators: [context_app: :dutchpay]

# Configure esbuild (the version is required)
# config :esbuild,
#   version: "0.25.0",
#   dutchpay_web: [
#     args:
#       ~w(js/app.js --bundle --target=es2021 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
#     cd: Path.expand("../apps/dutchpay_web/assets", __DIR__),
#     env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
#   ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure tailwind (the version is required)
# config :tailwind,
#   version: "4.0.6",
#   dutchpay_web: [
#     args: ~w(
#       --input=assets/css/app.css
#       --output=../priv/static/assets/app.css
#     ),
#     # Import environment specific config. This must remain at the bottom
#     # of this file so it overrides the configuration defined above.
#     cd: Path.expand("../apps/dutchpay_web", __DIR__)
#   ]
#
config :bun,
  version: "1.2.2",
  dutchpay_web@js: [
    args: ~w(build ./js/app.ts --outdir ../priv/static/assets --sourcemap=linked),
    cd: Path.expand("../apps/dutchpay_web/assets", __DIR__),
    env: %{}
  ],
  # dutchpay_web@js_build: [
  #   args: ~w(run js:build),
  #   cd: Path.expand("../apps/dutchpay_web/assets", __DIR__)
  # ],
  dutchpay_web@tailwind: [
    args: ~w(run tailwindcss),
    cd: Path.expand("../apps/dutchpay_web/assets", __DIR__),
    env: %{}
  ]

# dutchpay_web@lint: [
#   args: ~w(run )
# ]

# dutchpay_web@tailwind_build: [
#   args: ~w(run tailwind:build),
#   cd: Path.expand("../apps/dutchpay_web/assets", __DIR__)
# ]

import_config "#{config_env()}.exs"
