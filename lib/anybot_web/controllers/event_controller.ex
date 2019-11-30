defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger
  alias Anybot.{Slack, Storage}

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

      input =
        text
        |> String.replace(~r/<@[A-Z0-9]+> /, "")
        |> String.replace("\u201d", "\"")
        |> String.replace("\u2019", "'")
        |> String.replace("\u2014", "--")
        |> String.replace(~r/<[^ |]+([^ |]+)\|\1>/, "\\1")
        |> String.replace(~r/\<(https?:\/\/[^>]+)\>/, "\\1")

      Logger.info("Running #{inspect(input)}")

      case Anybot.Command.parse(input) do
        {:eval, code} ->
          result = Anybot.Lua.run(code)
          message = "`#{result}`"
          Slack.post_message(message, channel)

        {:run, name} ->
          code = Storage.get(name)
          result = Anybot.Lua.run(code)
          message = "`#{result}`"
          Slack.post_message(message, channel)

        {:save, name, program} ->
          :ok = Storage.put(name, program)
          Slack.post_message("Saved #{name}", channel)

        {:list} ->
          Storage.keys()
          |> Enum.map(fn item -> "* #{item}\n" end)
          |> Slack.post_message(channel)

        {:show, name} ->
          program = Storage.get(name)
          Slack.post_message("#{name}:\n```#{program}```", channel)

        {:delete, name} ->
          Storage.delete(name)
          Slack.post_message("Deleted #{name}", channel)

        {:error, message} ->
          Slack.post_message("Error: #{message}", channel)

        {:help} ->
          Slack.post_message(Anybot.Command.help_text(), channel)
      end
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
