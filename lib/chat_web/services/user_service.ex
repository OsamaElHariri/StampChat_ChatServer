defmodule ChatWeb.UserService do
  import Ecto.Query
  alias Chat.{Repo, User}

  def add_user(identity, name) do
    user =
      Repo.one(
        from u in User,
          where: u.identity == type(^identity, :string)
      )

    if user == nil do
      {:ok, u} =
        Repo.insert(%User{
          friendly_name: name,
          identity: identity
        })

      u
    else
      user
    end
  end
end
