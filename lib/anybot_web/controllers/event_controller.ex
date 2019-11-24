defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger
  alias Anybot.Slack

  def create(conn, %{"challenge" => challenge, "type" => "url_verification"} = params) do
    Logger.debug(inspect(conn.req_headers))
    Logger.debug(inspect(params))

    if Slack.verify(conn) do
      conn
      |> send_resp(200, challenge)
    else
      conn
      |> send_resp(403, "no")
    end
  end

  def create(conn, %{"event" => %{"type" => "app_mention", "text" => text, "channel" => channel}}) do
    Logger.info("App mention: " <> inspect(conn.assigns.raw_body))

    if Slack.verify(conn) do
      Logger.info("Verified signature")

      code =
        text
        |> String.replace(~r/<@[A-Z0-9]+> /, "")
        |> String.replace("\u201", "\"")
        |> String.replace("\u2019", "'")
        |> String.replace("\u2014", "--")

      Logger.info("Running #{inspect(code)}")
      result = Anybot.Lua.run(Anybot.Lua, code)

      Slack.post_message(
        "Yes, #{inspect(result)}",
        channel
      )
    else
      Logger.info("Bad signature")
    end

    conn
    |> send_resp(200, "ok")
  end

  def create(conn, _) do
    Logger.info("Unhandled event: " <> inspect(conn.assigns.raw_body))

    if Slack.verify(conn) do
      Logger.info("Verified signature")

      Slack.post_message(
        "Reminder: we've got a softball game tonight! `#{conn.assigns.raw_body}`",
        "GQT3XE3EG"
      )
    else
      Logger.info("Bad signature")
    end

    conn
    |> send_resp(200, "ok")
  end
end
