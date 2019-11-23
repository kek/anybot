defmodule Anybot.Lua do
  use GenServer
  require Logger

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  def init([]) do
    lua = :luerl_sandbox.init()
    {:ok, %{lua: lua}}
  end

  def run(code_runner, code) do
    GenServer.call(code_runner, {:run, code})
  end

  def handle_call({:run, code}, _, state) do
    {result, lua} =
      case :luerl_sandbox.run(code, state.lua, 100_000) do
        {:error, reason} ->
          {reason, state.lua}

        {result, lua} ->
          {result, lua}
      end

    {:reply, result, %{state | lua: lua}}
  end
end
