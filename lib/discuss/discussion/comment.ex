defmodule Discuss.Discussion.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Discussion.Topic
  alias Discuss.Identity.User

  @derive {Jason.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

  def changeset(comment, %Topic{} = topic, %User{} = user, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:topic, topic)
    |> put_assoc(:user, user)
  end

  def changeset(comment, attrs, %Topic{} = topic) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:topic, topic)
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
