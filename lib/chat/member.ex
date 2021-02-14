defmodule Chat.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    timestamps()

    field :is_participant, :boolean

    belongs_to :user, Chat.User
    belongs_to :channel, Chat.Channel
    has_many :messages, Chat.Message
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
