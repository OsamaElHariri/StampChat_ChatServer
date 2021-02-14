defmodule Chat.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    timestamps()
    field :friendly_name, :string
    field :identity, :string

    has_many :memberships, Chat.Member
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:identity, :friendly_name])
    |> validate_required([:identity, :friendly_name])
  end
end
