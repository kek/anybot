defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger

  def create(
        conn,
        %{"challenge" => challenge, "token" => token, "type" => "url_verification"} = params
      ) do
    [slack_request_timestamp] = get_req_header(conn, "x-slack-request-timestamp")
    [slack_signature] = get_req_header(conn, "x-slack-signature")
    _ = challenge
    _ = token
    _ = slack_request_timestamp
    _ = slack_signature
    Logger.debug(inspect(conn.req_headers))
    Logger.debug(inspect(params))

    body = conn.assigns.raw_body

    basestring = "v0:#{slack_request_timestamp}:#{body}"

    signed =
      :crypto.hmac(:sha256, Application.get_env(:anybot, :slack_signing_secret), basestring)
      |> Base.encode16()

    if signed == slack_signature do
      Logger.info("Computed signature #{signed} did match incoming signature #{slack_signature}")

      conn
      |> send_resp(200, challenge)
    else
      Logger.info("Computed signature #{signed} did not incoming signature #{slack_signature}")

      conn
      |> send_resp(403, "no")
    end
  end

  def create(conn, _) do
    Logger.info(inspect(conn.assigns.raw_body))

    conn
    |> send_resp(200, "yolo")
  end
end
