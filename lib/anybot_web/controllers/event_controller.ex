defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger

  def create(
        conn,
        %{"challenge" => challenge, "type" => "url_verification"} = params
      ) do
    Logger.debug(inspect(conn.req_headers))
    Logger.debug(inspect(params))
    [slack_request_timestamp] = get_req_header(conn, "x-slack-request-timestamp")
    [slack_signature] = get_req_header(conn, "x-slack-signature")

    if verify(
         conn.assigns.raw_body,
         slack_request_timestamp,
         slack_signing_secret(),
         slack_signature
       ) do
      conn
      |> send_resp(200, challenge)
    else
      conn
      |> send_resp(403, "no")
    end
  end

  def create(conn, _) do
    Logger.info("Unhandled event: " <> inspect(conn.assigns.raw_body))
    [slack_signature] = get_req_header(conn, "x-slack-signature")
    [slack_request_timestamp] = get_req_header(conn, "x-slack-request-timestamp")

    if verify(
         conn.assigns.raw_body,
         slack_request_timestamp,
         slack_signing_secret(),
         slack_signature
       ) do
      Logger.info("Verified signature")

      HTTPoison.post!(
        "https://slack.com/api/chat.postMessage",
        {:multipart,
         [
           {"text", "Reminder: we've got a softball game tonight! `#{conn.assigns.raw_body}`"},
           {"token", slack_bot_token()},
           {"channel", "GQT3XE3EG"}
         ]}
      )
    else
      Logger.info("Bad signature")
    end

    conn
    |> send_resp(200, "ok")
  end

  defp verify(body, slack_request_timestamp, slack_signing_secret, slack_signature) do
    basestring = "v0:#{slack_request_timestamp}:#{body}"

    signed =
      "v0=" <>
        (:crypto.hmac(:sha256, slack_signing_secret, basestring)
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

  defp slack_signing_secret do
    Application.get_env(:anybot, :slack_signing_secret)
  end

  defp slack_bot_token do
    Application.get_env(:anybot, :slack_bot_token)
  end
end
