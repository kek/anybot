defmodule LuerlTest do
  use ExUnit.Case

  @tag :pending
  test "What is wrong with returning tables" do
    lua = :luerl.init()

    fun = fn [], lua -> {[[]], lua} end

    fun_with_table = fn [], lua ->
      {res, lua} = :luerl.do("return {A = 1}", lua)
      {res, lua}
    end

    no_fun = fn [], lua ->
      {res, lua} = :luerl.do("return function() return 1 end", lua)
      {res, lua}
    end

    lua = :luerl.set_table([:fun], fun, lua)
    lua = :luerl.set_table([:fun_with_table], fun_with_table, lua)
    lua = :luerl.set_table([:no_fun], no_fun, lua)

    {res, lua} = :luerl.do("return fun()", lua)
    assert res == [{:tref, 13}]

    {res, lua} = :luerl.do("return fun_with_table()", lua)
    assert res == [{:tref, 14}]

    {res, _lua} = :luerl.do("return no_fun()", lua)
    assert res == :"???"
  end
end
