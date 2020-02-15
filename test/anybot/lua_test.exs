defmodule Anybot.LuaTest do
  use ExUnit.Case

  alias Anybot.{Storage, Lua}

  test "running code" do
    {:ok, runner} = Lua.start_link()

    assert Lua.run(runner, "return 1+1") == [2.0]
  end

  test "not returning anything" do
    {:ok, runner} = Lua.start_link()

    assert Lua.run(runner, "local x = 0") == []
  end

  test "requiring stored code" do
    {:ok, runner} = Lua.start_link()

    :ok = Storage.put("two", "return 1+1")
    assert Lua.run(runner, "return require('two')") == [2.0]
  end

  test "requiring stored code with a side effect" do
    {:ok, runner} = Lua.start_link()

    :ok = Storage.put("inc", "x = x + 1; return 0")
    assert Lua.run(runner, "x = 1; require('inc'); return x") == [2.0]
  end

  @tag :pending
  test "requiring stored code that returns a table" do
    {:ok, runner} = Lua.start_link()

    :ok = Storage.put("table", "return {SURPRISE = 12345678}")
    [table] = Lua.run(runner, "return require('table')")
    assert table == {:tref, 4}
    lua = :sys.get_state(runner).lua
    IO.inspect(:luerl_emul.get_table_keys(table, lua))
  end

  test "requiring stored code that contains an error" do
    {:ok, runner} = Lua.start_link()

    :ok = Storage.put("two", "return 1/0")
    assert Lua.run(runner, "return require('two') .. '!'") == ["badarith error in two!"]
  end

  test "returning a function" do
    {:ok, runner} = Lua.start_link()

    assert Lua.run(runner, "return function(x) return 1 end") ==
             [{:lua_func, 1, 0, [], [1], [push_last_lit: 1.0, return: 1]}]
  end

  test "Lua implemented function that returns a table" do
    {:ok, runner} = Lua.start_link()

    assert [tref: _] = Lua.run(runner, "return make_table()")
  end

  @tag :pending
  test "Lua implemented function that returns a function" do
    {:ok, runner} = Lua.start_link()

    assert Lua.run(runner, "return make_function()") == :"???"
  end

  test "Natively implemented function that returns a function" do
    {:ok, runner} = Lua.start_link()

    assert Lua.run(runner, "return make_native_function()()") == ["ok"]
  end

  test "Loading code from other programs" do
    for program_name <- Storage.keys() do
      Storage.delete(program_name)
    end

    program_path = "test/fixtures/lua"
    {:ok, runner} = Lua.start_link()

    for filename <- File.ls!("#{program_path}") do
      program_name = String.replace(filename, ".lua", "")
      code = File.read!("#{program_path}/#{filename}")
      Storage.put(program_name, code)
    end

    code = Storage.get("two")
    assert code
    assert Lua.run(runner, code) == ["ok"]
  end

  test "Is require reserved?" do
    {:ok, runner} = Lua.start_link()

    assert Lua.run(runner, "require('test'); return 'ok'") == ["ok"]
  end
end
