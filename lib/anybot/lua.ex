defmodule Anybot.Lua do
  use GenServer
  require Logger

  @max_reductions 10_000_000

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  def init([]) do
    get = fn [url], lua ->
      result = HTTPoison.get!(url)
      {[result], lua}
    end

    decode = fn [json], lua ->
      result = Jason.decode!(json)
      {[result], lua}
    end

    run = fn [program_name], lua ->
      code = Anybot.Storage.get(program_name)

      case :luerl_sandbox.run(code, lua, @max_reductions) do
        {:error, reason} ->
          {["#{reason} error in #{program_name}"], lua}

        {result, lua} ->
          # IO.inspect(program_name, label: "Run ok")
          # IO.inspect(result, label: "Run result")
          {result, lua}
      end
    end

    lua = :luerl_sandbox.init()
    lua = :luerl.set_table([:get], get, lua)
    lua = :luerl.set_table([:decode], decode, lua)
    lua = :luerl.set_table([:run], run, lua)

    {:ok, %{lua: lua}}
  end

  def run(code) do
    run(Anybot.Lua, code)
  end

  def run(code_runner, code) do
    GenServer.call(code_runner, {:run, code})
  end

  def handle_call({:run, code}, _, state) do
    # IO.inspect(code, label: "trying to run")

    {result, lua} =
      case :luerl_sandbox.run(code, state.lua, @max_reductions) do
        {:error, reason} ->
          # IO.inspect("error", label: code)
          # IO.inspect(reason, label: code)

          {reason, state.lua}

        {result, lua} ->
          # IO.inspect(result, label: code)

          {result, lua}
      end

    {:reply, result, %{state | lua: lua}}
  end
end
