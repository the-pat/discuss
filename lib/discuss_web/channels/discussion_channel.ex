defmodule DiscussWeb.DiscussionChannel do
  use Phoenix.Channel

  alias Discuss.Discussion

  def join("discussion:" <> topic_id, _params, socket) do
    topic =
      topic_id
      |> String.to_integer()
      |> Discussion.get_topic!(true)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in("discussion:comment", %{"content" => content}, %Phoenix.Socket{assigns: %{user: user, topic: topic}} = socket) do
    case Discussion.create_comment(topic.id, user.id, %{content: content}) do
     {:ok, comment} ->
       comment = %Discussion.Comment{comment | user: user}
       broadcast!(socket, "discussion:#{topic.id}:new", %{comment: comment})
       {:reply, :ok, socket}

     {:error, %Ecto.Changeset{} = changeset} ->
       {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_in("discussion:comment", _params, socket), do: {:reply, :error, socket}
end
