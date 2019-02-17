defmodule Discuss.Discussion.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Discussion.Topic
  alias Discuss.Identity.User

  @derive {Jason.Encoder, only: [:content, :user]}

  schema "comments" do
    field :content, :string
    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :topic_id, :user_id])
    |> validate_required([:content, :topic_id, :user_id])
    |> foreign_key_constraint(:topic_id)
    |> foreign_key_constraint(:user_id)
  end
end
