defmodule AnybotWeb.PageLive do
  use Phoenix.LiveView
  alias Anybot.Storage

  @spec render(Phoenix.LiveView.Socket.t()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <%= for {name, code} <- @programs do %>
      <h2><%= name %></h2>
      <p><code><%= code %></code></p>
    <% end %>
    """
  end

  @spec mount(map, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(%{}, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :update)
    {:ok, assign(socket, :programs, programs())}
  end

  @spec handle_info(:update, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info(:update, socket) do
    {:noreply, assign(socket, :programs, programs())}
  end

  defp programs() do
    Storage.keys()
    |> Enum.map(fn key -> {key, Storage.get(key)} end)
    |> Map.new()
  end
end
