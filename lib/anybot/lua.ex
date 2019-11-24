defmodule Anybot.Lua do
  use GenServer
  require Logger

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

    lua = :luerl_sandbox.init()
    lua = :luerl.set_table([:get], get, lua)
    lua = :luerl.set_table([:decode], decode, lua)

    {:ok, %{lua: lua}}
  end

  def run(code) do
    run(Anybot.Lua, code)
  end

  def run(code_runner, code) do
    GenServer.call(code_runner, {:run, code})
  end

  def handle_call({:run, code}, _, state) do
    {result, lua} =
      case :luerl_sandbox.run(code, state.lua, 1_000_000) do
        {:error, reason} ->
          {reason, state.lua}

        {result, lua} ->
          {result, lua}
      end

    {:reply, result, %{state | lua: lua}}
  end
end
