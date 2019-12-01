defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger
  alias Anybot.Slack

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"challenge" => challenge, "type" => "url_verification"}) do
    if Slack.verify(conn) do
      conn
      |> send_resp(200, challenge)
    else
      conn
      |> send_resp(403, "no")
    end
  end

  def create(conn, %{"event" => %{"type" => "app_mention", "text" => text, "channel" => channel}}) do
    if Slack.verify(conn) do
      text = fix_slack_formatted_text(text)
      command = Anybot.Parser.parse(text)
      {:ok, reply} = Anybot.Command.perform(command)

      Slack.post_message(reply, channel)
    else
      Logger.info("Bad signature")
    end

    conn
    |> send_resp(200, "ok")
  end

  def create(conn, %{}) do
    Logger.warn("Unhandled event: " <> inspect(conn.assigns.raw_body))

    if Slack.verify(conn) do
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

  defp fix_slack_formatted_text(text) do
    text
    |> String.replace(~r/<@[A-Z0-9]+> /, "")
    |> String.replace("\u201d", "\"")
    |> String.replace("\u2019", "'")
    |> String.replace("\u2014", "--")
    |> String.replace(~r/<[^ |]+([^ |]+)\|\1>/, "\\1")
    |> String.replace(~r/\<(https?:\/\/[^>]+)\>/, "\\1")
  end
end
