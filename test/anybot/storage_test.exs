defmodule Anybot.StorageTest do
  use ExUnit.Case
  alias Anybot.Storage

  setup do
    clean_storage_directory()
    on_exit(&clean_storage_directory/0)
  end

  defp clean_storage_directory() do
    Application.get_env(:anybot, :storage_directory)
    |> File.rm_rf()
  end

  test "setting and getting" do
    Storage.put("foo", "bar")
    assert Storage.get("foo") == "bar"
  end

  test "deleting" do
    Storage.put("foo", "bar")
    assert Storage.get("foo") == "bar"
    Storage.delete("foo")
    assert Storage.get("foo") == nil
  end

  test "trying to get unknown value" do
    assert Storage.get("unknown") == nil
  end

  test "can not write files outside of storage directory" do
    assert Storage.put("../anybot-test-file", "contents") == {:error, :invalid_key}
    assert Storage.put("/etc/passwd", "contents") == {:error, :invalid_key}
  end

  test "can not read files outside of storage directory" do
    assert Storage.get("../anybot-test-file-2") == {:error, :invalid_key}
    assert Storage.get("/etc/passwd") == {:error, :invalid_key}
  end

  test "can not delete files outside of storage directory" do
    assert Storage.delete("../anybot-test-file-2") == {:error, :invalid_key}
    assert Storage.delete("/etc/passwd") == {:error, :invalid_key}
  end

  test "get all keys" do
    clean_storage_directory()
    assert Storage.keys() == []
    Storage.put("foo", "bar")
    assert Storage.keys() == ["foo"]
  end
end
