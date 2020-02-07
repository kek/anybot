defmodule Anybot.LuaTest do
  use ExUnit.Case

  test "running code" do
    {:ok, runner} = Anybot.Lua.start_link()

    assert Anybot.Lua.run(runner, "return 1+1") == [2.0]
  end

  test "not returning anything" do
    {:ok, runner} = Anybot.Lua.start_link()

    assert Anybot.Lua.run(runner, "local x = 0") == []
  end

  test "running stored code" do
    {:ok, runner} = Anybot.Lua.start_link()

    :ok = Anybot.Storage.put("two", "return 1+1")
    assert Anybot.Lua.run(runner, "return run('two')") == [2.0]
  end

  test "running stored code with a side effect" do
    {:ok, runner} = Anybot.Lua.start_link()

    :ok = Anybot.Storage.put("inc", "x = x + 1; return 0")
    assert Anybot.Lua.run(runner, "x = 1; run('inc'); return x") == [2.0]
  end

  @tag :pending
  test "running stored code that returns a table" do
    {:ok, runner} = Anybot.Lua.start_link()

    :ok = Anybot.Storage.put("table", "return {SURPRISE = 12345678}")
    [table] = Anybot.Lua.run(runner, "return run('table')")
    assert table == {:tref, 4}
    lua = :sys.get_state(runner).lua
    IO.inspect(:luerl_emul.get_table_keys(table, lua))
  end

  test "running stored code that contains an error" do
    {:ok, runner} = Anybot.Lua.start_link()

    :ok = Anybot.Storage.put("two", "return 1/0")
    assert Anybot.Lua.run(runner, "return run('two') .. '!'") == ["badarith error in two!"]
  end

  test "returning a function" do
    {:ok, runner} = Anybot.Lua.start_link()

    assert Anybot.Lua.run(runner, "return function(x) return 1 end") ==
             [{:lua_func, 1, 0, [], [1], [push_last_lit: 1.0, return: 1]}]
  end

  test "Lua implemented function that returns a table" do
    {:ok, runner} = Anybot.Lua.start_link()

    assert [tref: _] = Anybot.Lua.run(runner, "return make_table()")
  end

  @tag :pending
  test "Lua implemented function that returns a function" do
    {:ok, runner} = Anybot.Lua.start_link()

    assert Anybot.Lua.run(runner, "return make_function()") == :"???"
  end

  test "Natively implemented function that returns a function" do
    {:ok, runner} = Anybot.Lua.start_link()

    assert Anybot.Lua.run(runner, "return make_native_function()()") == ["ok"]
  end
end
