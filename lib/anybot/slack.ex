defmodule Anybot.Slack do
  require Logger

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

  def verify(conn) do
    [slack_signature] = Plug.Conn.get_req_header(conn, "x-slack-signature")
    [slack_request_timestamp] = Plug.Conn.get_req_header(conn, "x-slack-request-timestamp")
    basestring = "v0:#{slack_request_timestamp}:#{conn.assigns.raw_body}"

    signed =
      "v0=" <>
        (:crypto.hmac(:sha256, slack_signing_secret(), basestring)
         |> Base.encode16()
         |> String.downcase())

    if slack_signature == signed do
      Logger.info("Computed signature #{signed} did match incoming signature #{slack_signature}")
      true
    else
      Logger.info(
        "Computed signature #{signed} did not match incoming signature #{slack_signature}"
      )

      false
    end
  end

  defp slack_bot_token do
    Application.get_env(:anybot, :slack_bot_token)
  end

  defp slack_signing_secret do
    Application.get_env(:anybot, :slack_signing_secret)
  end
end
