defmodule DiscussWeb.DiscussionChannel do
  use Phoenix.Channel

  def join("discussion:" <> topic_id, _params, socket) do
    # TODO: send all of the comments for the given topic
    {:ok, %{topic_id: topic_id}, socket}
  end

  def handle_in(name, message, socket) do
    # TODO: save the comment and update the clients
    {:reply, :ok, socket}
  end
end
