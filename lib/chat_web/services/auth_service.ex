defmodule ChatWeb.AuthService do
  import Ecto.Query
  alias Chat.{Repo, User}

  def verify(token) do
    signer = Joken.Signer.create("HS256", "super_secret_key!")
    verification = Joken.verify_and_validate(Joken.Config.default_claims(), token, signer)

    case verification do
      {:ok, claims} ->
        {:ok,
         Repo.one(
           from u in User,
             where: u.identity == type(^claims["identity"], :string)
         )}

      {:error, _} ->
        verification
    end
  end
end
