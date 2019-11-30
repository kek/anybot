defmodule AnybotWeb.Router do
  use AnybotWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AnybotWeb do
    pipe_through :browser

    live "/", PageLive, session: [:user_id]
  end

  scope "/event", AnybotWeb do
    pipe_through :api

    post "/", EventController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", AnybotWeb do
  #   pipe_through :api
  # end
end
