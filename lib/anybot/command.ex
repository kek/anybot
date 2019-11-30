defmodule Anybot.Command do
  def help_text do
    """
    !save <name> <program>
    !delete <name>
    !show <name>
    !run <program>
    !list
    !help
    """
  end

  def parse("!save " <> rest) do
    name = rest |> String.split() |> Enum.at(0)
    code = String.trim_leading(rest, name <> " ")
    {:save, name, code}
  end

  def parse("!delete " <> name), do: {:delete, name}
  def parse("!list"), do: {:list}
  def parse("!help"), do: {:help}
  def parse("!show " <> name), do: {:show, name}
  def parse("!run " <> name), do: {:run, name}
  def parse(command = "!" <> _), do: {:error, "Unknown command #{command}"}

  def parse(input) do
    {:eval, input}
  end
end
