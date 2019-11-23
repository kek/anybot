defmodule Anybot.Slack do
  def post_message(text, channel) do
    HTTPoison.post!(
      "https://slack.com/api/chat.postMessage",
      {:multipart,
       [
         {"text", text},
         {"token", slack_bot_token()},
         {"channel", channel}
       ]}
    )
  end

  defp slack_bot_token do
    Application.get_env(:anybot, :slack_bot_token)
  end
end
