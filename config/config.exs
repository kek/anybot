# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :anybot, AnybotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x6eU9o3O0CPYPrPWNJKsbPmC9XZ3CQnN25ubRVmldbpp62vivsxtMw4zjI/gcqOq",
  render_errors: [view: AnybotWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Anybot.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "N3I91fX2IcspsJUlywyBB7tSKE/NiWJ0"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :anybot,
  slack_app_id: System.get_env("SLACK_APP_ID"),
  slack_client_id: System.get_env("SLACK_CLIENT_ID"),
  slack_client_secret: System.get_env("SLACK_CLIENT_SECRET"),
  slack_signing_secret: System.get_env("SLACK_SIGNING_SECRET"),
  slack_bot_token: System.get_env("SLACK_BOT_TOKEN")

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
