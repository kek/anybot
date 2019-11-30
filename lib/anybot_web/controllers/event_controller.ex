defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger
  alias Anybot.{Slack, Storage}

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
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
          message = "`#{code}` → `#{inspect(result)}`"
          Slack.post_message(message, channel)

        {:run, name} ->
          case Storage.get(name) do
            {:error, :invalid_key} ->
              Slack.post_message("Invalid key: #{name}", channel)

            code ->
              result = Anybot.Lua.run(code)
              message = "#{name} → `#{inspect(result)}`"
              Slack.post_message(message, channel)
          end

        {:save, name, program} ->
          case Storage.put(name, program) do
            :ok ->
              Slack.post_message("Saved #{name}", channel)

            {:error, :invalid_key} ->
              Slack.post_message("Invalid key: #{name}", channel)
          end

        {:list} ->
          case Storage.keys() do
            [] ->
              Slack.post_message("I don't know anything.", channel)

            keys ->
              message =
                "These are the programs I know:\n" <>
                  (keys
                   |> Enum.map(fn item -> "- #{item}" end)
                   |> Enum.join("\n"))

              Slack.post_message(message, channel)
          end

        {:show, name} ->
          case Storage.get(name) do
            {:error, :invalid_key} ->
              Slack.post_message("Invalid key: #{name}", channel)

            program ->
              Slack.post_message("#{name}:\n```#{program}```", channel)
          end

        {:delete, name} ->
          case Storage.delete(name) do
            {:error, :invalid_key} ->
              Slack.post_message("Invalid key: #{name}", channel)

            :ok ->
              Slack.post_message("Deleted #{name}", channel)
          end

        {:error, message} ->
          Slack.post_message("Error: `#{inspect(message)}`", channel)

        {:help} ->
          Slack.post_message(Anybot.Command.help_text(), channel)
      end
    else
      Logger.info("Bad signature")
    end

    conn
    |> send_resp(200, "ok")
  end

  def create(conn, %{}) do
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
