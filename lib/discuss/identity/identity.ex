defmodule Discuss.Identity do
  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Identity.User

  def get_user!(id), do: Repo.get(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

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

  def create_or_update_user(%{email: email} = attrs) do
    case get_user_by_email(email) do
      nil -> create_user(attrs)
      user -> update_user(user, attrs)
    end
  end
end
