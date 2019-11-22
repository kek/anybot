import Config

config :anybot,
  slack_app_id: System.get_env("SLACK_APP_ID"),
  slack_client_id: System.get_env("SLACK_CLIENT_ID"),
  slack_client_secret: System.get_env("SLACK_CLIENT_SECRET"),
  slack_signing_secret: System.get_env("SLACK_SIGNING_SECRET"),
  slack_bot_token: System.get_env("SLACK_BOT_TOKEN")
