defmodule AnybotWeb.PageLive do
  use Phoenix.LiveView
  alias Anybot.Storage

  def render(assigns) do
    ~L"""
    <h1>Current programs</h2>
    <%= for {name, code} <- @programs do %>
      <h2><%= name %></h2>
      <code>
        <%= code %>
      </code>
    <% end %>
    """
  end

  def mount(%{}, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :update)
    {:ok, assign(socket, :programs, programs())}
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, :programs, programs())}
  end

  defp programs() do
    Storage.keys()
    |> Enum.map(fn key -> {key, Storage.get(key)} end)
    |> Map.new()
  end
end
