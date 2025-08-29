# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :nectarine,
  ecto_repos: [Nectarine.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :nectarine, NectarineWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: NectarineWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Nectarine.PubSub,
  live_view: [signing_salt: "X0U/dDu5"]

config :nectarine, Nectarine.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username: "nectarine.app@gmail.com",
  password: "Nectarine123",
  tls: :if_available,
  retries: 1

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Absinthe schema
config :absinthe, :schema, NectarineWeb.Graphql.Schema

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
