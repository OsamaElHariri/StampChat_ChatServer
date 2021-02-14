defmodule Chat.Stamp do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stamps" do
    timestamps()
    field :word, :string
    field :x_pos, :float
    field :y_pos, :float
    field :strength, :float

    belongs_to :member, Chat.Member
    belongs_to :channel, Chat.Channel
    belongs_to :message, Chat.Message
  end

  @doc false
  def changeset(stamp, attrs) do
    stamp
    |> cast(attrs, [:word, :xPos, :yPos])
    |> validate_required([:word, :xPos, :yPos])
  end
end
