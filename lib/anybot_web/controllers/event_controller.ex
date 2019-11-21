defmodule AnybotWeb.EventController do
  use AnybotWeb, :controller
  require Logger

  def create(conn, params) do
    Logger.info(inspect(conn.req_headers))
    Logger.info(inspect(params))

    conn
    |> send_resp(200, "ok")
  end
end
