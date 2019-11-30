use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :anybot, AnybotWeb.Endpoint,
  http: [port: 4002],
  server: false

config :anybot,
  storage_directory: "/tmp/anybot-test"

# Print only warnings and errors during test
config :logger, level: :warn
