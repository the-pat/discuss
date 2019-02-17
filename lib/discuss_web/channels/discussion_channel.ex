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

  def handle_in("discussion:comment", %{"content" => content}, socket) do
    topic = socket.assigns.topic

    case Discussion.create_comment(topic, %{content: content}) do
     {:ok, comment} ->
       broadcast!(socket, "discussion:#{socket.assigns.topic_id}:new", %{comment: comment})
       {:reply, :ok, socket}
     {:error, _reason} ->
       {:reply, {:error, %{errors: :wat}}, socket}
    end

    {:reply, :ok, socket}
  end
end
