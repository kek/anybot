defmodule Anybot.CommandTest do
  use ExUnit.Case

  test "defaults to run code" do
    assert Anybot.Command.parse("10 GOTO 10") == {:run, "10 GOTO 10"}
  end

  test "Special commands" do
    assert Anybot.Command.parse("!save name code") == {:save, "name", "code"}
    assert Anybot.Command.parse("!delete name") == {:delete, "name"}
    assert Anybot.Command.parse("!list") == {:list}
    assert Anybot.Command.parse("!show name") == {:show, "name"}
    assert Anybot.Command.parse("!help") == {:help}
  end

  test "Don't know" do
    assert Anybot.Command.parse("!something") == {:error, "Unknown command !something"}
  end

  # ### `!save <name> <program>`
  # Save a program and run it. The code will be run again at restart.

  # ### `!delete <name>`
  # Removes a program so that it won't be run at next restart.

  # ### `!list`
  # List saved programs.

  # ### `!show <name>`
  # Shows the code for a saved program.

  # ### `!help`
  # Display help for these commands.
end
