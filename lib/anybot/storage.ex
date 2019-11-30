defmodule Anybot.Storage do
  def put(key, value) do
    with :ok <- validate_key(key) do
      :ok = File.mkdir_p(storage_path())
      path = Path.join(storage_path(), key)
      :ok = File.write(path, value)
    end
  end

  def get(key) do
    with :ok <- validate_key(key) do
      path = Path.join(storage_path(), key)

      case File.read(path) do
        {:ok, value} -> value
        {:error, :enoent} -> nil
      end
    end
  end

  def delete(key) do
    with :ok <- validate_key(key) do
      path = Path.join(storage_path(), key)
      File.rm(path)
    end
  end

  def keys() do
    File.mkdir_p(storage_path())
    File.ls!(storage_path())
  end

  defp validate_key(key) do
    case key =~ ~r/^[a-z]+$/ do
      true -> :ok
      false -> {:error, :invalid_key}
    end
  end

  defp storage_path do
    Application.get_env(:anybot, :storage_directory)
  end
end
