defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Discussion
  alias Discuss.Discussion.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Discussion.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Discussion.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Discussion.create_topic(conn.assigns.user.id, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Discussion.get_topic!(topic_id)
    render(conn, "show.html", topic: topic)
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = conn.assigns.topic || Discussion.get_topic!(topic_id)
    changeset = Discussion.change_topic(topic)
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = conn.assigns.topic || Discussion.get_topic!(topic_id)

    case Discussion.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: Routes.topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = conn.assigns.topic || Discussion.get_topic!(topic_id)
    {:ok, _topic} = Discussion.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if (topic = conn.assigns.user && Discussion.get_topic!(topic_id)).user_id == conn.assigns.user.id do
      conn
      |> assign(:topic, topic)
    else
      conn
      |> put_flash(:error, "You cannot mess with this topic!")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
