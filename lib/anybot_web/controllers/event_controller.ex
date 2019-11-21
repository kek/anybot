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
    Logger.info(inspect(conn.req_headers))
    Logger.info(inspect(params))

    response = "ok"

    conn
    |> send_resp(200, response)
  end
end
