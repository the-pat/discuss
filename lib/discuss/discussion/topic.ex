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

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
