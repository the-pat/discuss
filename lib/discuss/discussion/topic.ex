defmodule Discuss.Discussion.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Identity.User
  alias Discuss.Discussion.Comment

  schema "topics" do
    field :title, :string
    belongs_to :user, User
    has_many :comments, Comment

    timestamps()
  end

  def changeset(topic, attrs, %User{} = user) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> put_assoc(:user, user)
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
