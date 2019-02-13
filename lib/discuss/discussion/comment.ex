defmodule Discuss.Discussion.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.Identity.User
    belongs_to :topic, Discuss.Discussion.Topic

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user, :topic])
    |> validate_required([:content, :user, :topic])
  end
end
