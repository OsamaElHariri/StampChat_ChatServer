defmodule Chat.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    timestamps()

    field :friendly_name, :string
    field :topic, :string

    has_many :messages, Chat.Message
    has_many :members, Chat.Member
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:topic, :friendly_name])
    |> validate_required([:topic, :friendly_name])
  end
end
