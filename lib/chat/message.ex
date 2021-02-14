defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    timestamps()

    field :body, :string
    field :type, :string

    belongs_to :member, Chat.Member
    belongs_to :channel, Chat.Channel
    has_many :stamps, Chat.Stamp
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :type])
    |> validate_required([:body, :type])
  end
end
