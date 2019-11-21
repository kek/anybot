defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger

  def create(conn, params) do
    Logger.debug(inspect(conn.req_headers))

    conn
    |> send_resp(200, "ok")
  end
end
