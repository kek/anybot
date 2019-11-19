defmodule AnybotWeb.PageController do
  use AnybotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
