defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel "discussion:*", DiscussWeb.DiscussionChannel

  def connect(%{"token" => token}, socket, _connect_info) do
    key = Application.get_env(:discuss, DiscussWeb.Endpoint)[:socket_secret_key]

    case Phoenix.Token.verify(socket, key, token, max_age: 86400) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, _error} ->
        :error
    end
  end

  def id(_socket), do: nil
end
