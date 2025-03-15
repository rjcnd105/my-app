# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ex_cldr, default_backend: Deopjib.Cldr

config :deopjib, Oban,
  engine: Oban.Engines.Basic,
  notifier: Oban.Notifiers.Postgres,
  queues: [default: 10],
  repo: Deopjib.Repo

config :ash,
  allow_forbidden_field_for_relationships_by_default?: true,
  include_embedded_source_by_default?: false,
  show_keysets_for_all_actions?: false,
  default_page_type: :keyset,
  policies: [no_filter_static_forbidden_reads?: false]

config :ash, :policies, no_filter_static_forbidden_reads?: false

config :spark,
  formatter: [
    remove_parens?: true,
    "Ash.Resource": [
      section_order: [
        :admin,
        :authentication,
        :tokens,
        :postgres,
        :resource,
        :code_interface,
        :actions,
        :policies,
        :pub_sub,
        :preparations,
        :changes,
        :validations,
        :multitenancy,
        :attributes,
        :relationships,
        :calculations,
        :aggregates,
        :identities
      ]
    ],
    "Ash.Domain": [
      section_order: [:admin, :resources, :policies, :authorization, :domain, :execution]
    ]
  ]

config :deopjib,
  ecto_repos: [Deopjib.Repo],
  generators: [timestamp_type: :utc_datetime],
  ash_domains: [Deopjib.Accounts, Deopjib.Settlement]

# Configures the endpoint
config :deopjib, DeopjibWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DeopjibWeb.ErrorHTML, json: DeopjibWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Deopjib.PubSub,
  live_view: [signing_salt: "mFm5mUGx"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :deopjib, Deopjib.Mailer, adapter: Swoosh.Adapters.Local

config :bun,
  version: "1.2.4",
  app@js: [
    args: ~w(run js),
    cd: Path.expand("../", __DIR__),
    env: %{}
  ],
  # dutchpay_web@js_build: [
  #   args: ~w(run js:build),
  #   cd: Path.expand("../assets", __DIR__)
  # ],
  app@tailwind: [
    args: ~w(run tailwind),
    cd: Path.expand("../", __DIR__),
    env: %{}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
