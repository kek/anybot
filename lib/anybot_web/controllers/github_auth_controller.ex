defmodule AnybotWeb.GithubAuthController do
  use AnybotWeb, :controller

  @doc """
  `index/2` handles the callback from GitHub Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, profile} = ElixirAuthGithub.github_auth(code)

    conn
    |> put_session(:github_profile, profile)
    |> put_view(AnybotWeb.PageView)
    |> render(:welcome, profile: profile)
  end
end
