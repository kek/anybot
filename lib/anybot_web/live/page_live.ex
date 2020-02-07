defmodule Program do
  defstruct name: nil, code: nil
end

defmodule AnybotWeb.PageLive do
  use Phoenix.LiveView
  alias Anybot.Storage

  @spec render(Phoenix.LiveView.Socket.t()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    Phoenix.View.render(AnybotWeb.PageView, "page.html", assigns)
  end

  @spec mount(map, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(%{github_profile: github_profile}, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :update)

    {:ok,
     socket
     |> assign(:github_profile, github_profile)
     |> assign(:programs, programs())}
  end

  @spec handle_info(:update, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info(:update, socket) do
    {:noreply, assign(socket, :programs, programs())}
  end

  def handle_event("delete", %{"program" => %{"name" => program_name}}, socket) do
    if authorized?(socket) do
      Anybot.Storage.delete(program_name)
    end

    {:noreply, socket}
  end

  def handle_event("validate", %{"program" => %{"name" => program_name, "code" => code}}, socket) do
    if authorized?(socket) do
      Anybot.Storage.put(program_name, code)
    end

    {:noreply, socket}
  end

  def handle_event("new_program", %{"new_program" => %{"name" => program_name}}, socket) do
    if authorized?(socket) do
      Anybot.Storage.put(program_name, "")
    end

    {:noreply, socket}
  end

  defp programs() do
    Storage.keys()
    |> Enum.map(fn key -> %Program{name: key, code: Storage.get(key)} end)
  end

  defp authorized?(socket) do
    login = socket.assigns.github_profile.login

    Application.get_env(:anybot, :authorized_users)
    |> Enum.member?(login)
  end
end
