defmodule Anybot.ParserTest do
  use ExUnit.Case

  test "defaults to run code" do
    assert Anybot.Parser.parse("10 GOTO 10") == {:eval, "10 GOTO 10"}
  end

  test "Special commands" do
    assert Anybot.Parser.parse("!save name code") == {:save, "name", "code"}
    assert Anybot.Parser.parse("!delete name") == {:delete, "name"}
    assert Anybot.Parser.parse("!list") == {:list}
    assert Anybot.Parser.parse("!show name") == {:show, "name"}
    assert Anybot.Parser.parse("!help") == {:help}
    assert Anybot.Parser.parse("!run name") == {:run, "name"}
  end

  test "Don't know" do
    assert Anybot.Parser.parse("!something") == {:error, "Unknown command !something"}
  end

  test "Decodes entities" do
    assert Anybot.Parser.parse("return 1 &lt;&gt; 0") == {:eval, "return 1 <> 0"}
  end
end
