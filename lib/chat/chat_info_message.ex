defmodule Chat.ChatInfoMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_info_messages" do
    timestamps()

    field :body, :string
    field :type, :string
  end

  @doc false
  def changeset(chat_info_message, attrs) do
    chat_info_message
    |> cast(attrs, [:body, :type])
    |> validate_required([:body, :type])
  end
end
