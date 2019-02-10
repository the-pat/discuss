defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Identity
  alias Discuss.Identity.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: Atom.to_string(auth.provider)}

    case Identity.create_or_update_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in successful.")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Error authenticating.")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end
end
