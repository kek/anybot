defmodule Anybot.Command do
  def parse("!save " <> rest) do
    name = rest |> String.split() |> Enum.at(0)
    code = String.trim_leading(rest, name <> " ")
    {:save, name, code}
  end

  def parse("!delete " <> name), do: {:delete, name}

  def parse("!list"), do: {:list}

  def parse("!help"), do: {:help}

  def parse("!show " <> name), do: {:show, name}

  def parse(command = "!" <> _), do: {:error, "Unknown command #{command}"}

  def parse(input) do
    {:run, input}
  end
end
