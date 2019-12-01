import Config

config :anybot,
  slack_app_id: System.get_env("SLACK_APP_ID"),
  slack_client_id: System.get_env("SLACK_CLIENT_ID"),
  slack_client_secret: System.get_env("SLACK_CLIENT_SECRET"),
  slack_signing_secret: System.get_env("SLACK_SIGNING_SECRET"),
  slack_bot_token: System.get_env("SLACK_BOT_TOKEN"),
  storage_directory: Path.join(System.get_env("HOME"), ".anybot-storage")

config :anybot, AnybotWeb.Endpoint, url: [host: System.get_env("WEB_SERVER_HOST"), port: 443]
