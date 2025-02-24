import Config
config :deopjib, Oban, testing: :manual
config :deopjib, token_signing_secret: "js6fZJcq9D1CYc0IgurgDfmcgdfuZKFU"
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :deopjib, Deopjib.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "deopjib_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :deopjib, DeopjibWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HupAKiujHZqkDolDnjDopGhrYq0ADaUFFUa4Lg9uFu2ceAuO1VGNpAtGXwlFZvrw",
  server: false

# In test we don't send emails
config :deopjib, Deopjib.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
