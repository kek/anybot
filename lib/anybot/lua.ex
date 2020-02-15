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

    require_program = fn [program_name], lua ->
      code = Anybot.Storage.get(program_name)

      case :luerl_sandbox.run(code, lua, @max_reductions) do
        {:error, reason} ->
          {["#{reason} error in #{program_name}"], lua}

        {result, lua} ->
          # Perhaps put result in a table/list
          {result, lua}
      end
    end

    make_table = fn _, lua ->
      {res, lua} = :luerl.do("return {}", lua)
      {[res], lua}
    end

    make_function = fn _, lua ->
      {res, lua} = :luerl.do("return function() return 1 end", lua)
      {[res], lua}
    end

    make_native_function = fn _, lua ->
      {[fn [] -> ["ok"] end], lua}
    end

    lua = :luerl_sandbox.init()
    lua = :luerl.set_table([:get], get, lua)
    lua = :luerl.set_table([:decode], decode, lua)
    lua = :luerl.set_table([:require], require_program, lua)
    lua = :luerl.set_table([:make_table], make_table, lua)
    lua = :luerl.set_table([:make_function], make_function, lua)
    lua = :luerl.set_table([:make_native_function], make_native_function, lua)

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
      case :luerl_sandbox.run(code, state.lua, @max_reductions) do
        {:error, reason} ->
          {reason, state.lua}

        {result, lua} ->
          {result, lua}
      end

    {:reply, result, %{state | lua: lua}}
  end
end
