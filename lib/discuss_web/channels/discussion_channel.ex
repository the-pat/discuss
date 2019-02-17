defmodule DiscussWeb.DiscussionChannel do
  use Phoenix.Channel

  alias Discuss.{Discussion, Identity}

  def join("discussion:" <> topic_id, _params, socket) do
    topic =
      topic_id
      |> String.to_integer()
      |> Discussion.get_topic!(true)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in("discussion:comment", %{"content" => content}, socket) do
    topic_id = socket.assigns.topic.id
    user_id = socket.assigns.user_id

    case Discussion.create_comment(topic_id, user_id, %{content: content}) do
     {:ok, comment} ->
       broadcast!(socket, "discussion:#{topic_id}:new", %{comment: comment})
       {:reply, :ok, socket}

     {:error, %Ecto.Changeset{} = changeset} ->
       {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
