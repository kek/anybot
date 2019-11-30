defmodule Anybot.CommandTest do
  use ExUnit.Case

  test "defaults to run code" do
    assert Anybot.Command.parse("10 GOTO 10") == {:eval, "10 GOTO 10"}
  end

  test "Special commands" do
    assert Anybot.Command.parse("!save name code") == {:save, "name", "code"}
    assert Anybot.Command.parse("!delete name") == {:delete, "name"}
    assert Anybot.Command.parse("!list") == {:list}
    assert Anybot.Command.parse("!show name") == {:show, "name"}
    assert Anybot.Command.parse("!help") == {:help}
    assert Anybot.Command.parse("!run name") == {:run, "name"}
  end

  test "Don't know" do
    assert Anybot.Command.parse("!something") == {:error, "Unknown command !something"}
  end
end
