defmodule ChatWeb.AuthService do
  import Ecto.Query
  alias Chat.{Repo, User}

  def verify(token) do
    private_key = Application.get_env(:auth_service, :private_key)

    signer = Joken.Signer.create("HS256", private_key)
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
