defmodule Discuss.Identity do
  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Identity.User

  def get_user!(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def insert_or_update_user(attrs) do
    # TODO
  end
end
