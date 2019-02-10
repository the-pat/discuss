defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Identity.User
  alias DiscussWeb.Router.Helpers

  def init(_params) do
    # noop
  end

  def call(conn, _params) do
    if conn.assigns[:user] do

    else
    end

    case conn.assigns[:user] do
      %User{} ->
        conn

      _ ->
        conn
        |> put_flash(:error, "You must be logged in.")
        |> redirect(to: Helpers.topic_path(conn, :index))
        |> halt()
    end
  end
end
