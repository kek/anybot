defmodule Anybot.Command do
  alias Anybot.{Storage, Lua}

  @spec perform(
          {:help}
          | {:list}
          | {:delete, binary}
          | {:error, any}
          | {:eval, binary}
          | {:run, binary}
          | {:show, binary}
          | {:save, binary, binary}
        ) :: {:ok, binary}
  def perform({:eval, code}) do
    result = Lua.run(code)
    message = "`#{code}` → `#{inspect(result)}`"
    {:ok, message}
  end

  def perform({:run, name}) do
    case Storage.get(name) do
      {:error, :invalid_key} ->
        {:ok, "Invalid key: #{name}"}

      nil ->
        {:ok, "I don't know anything about #{name}."}

      code ->
        result = Anybot.Lua.run(code)
        message = "#{name} → `#{inspect(result)}`"
        {:ok, message}
    end
  end

  def perform({:save, name, program}) do
    case Storage.put(name, program) do
      :ok -> {:ok, "Saved #{name}"}
      {:error, :invalid_key} -> {:ok, "Invalid key: #{name}"}
    end
  end

  def perform({:list}) do
    case Storage.keys() do
      [] -> {:ok, "I don't know anything."}
      keys -> {:ok, format_program_list(keys)}
    end
  end

  def perform({:show, name}) do
    case Storage.get(name) do
      {:error, :invalid_key} -> {:ok, "Invalid key: #{name}"}
      nil -> {:ok, "I don't know anything about #{name}."}
      program -> {:ok, "#{name}:\n```#{program}```"}
    end
  end

  def perform({:delete, name}) do
    case Storage.delete(name) do
      {:error, :invalid_key} -> {:ok, "Invalid key: #{name}"}
      :ok -> {:ok, "Deleted #{name}"}
    end
  end

  def perform({:error, message}) do
    {:ok, "Error: `#{inspect(message)}`"}
  end

  def perform({:help}) do
    {:ok, Anybot.Parser.help_text()}
  end

  defp format_program_list(keys) do
    "These are the programs I know:\n" <>
      (keys
       |> Enum.map(fn item -> "- #{item}" end)
       |> Enum.join("\n"))
  end
end
