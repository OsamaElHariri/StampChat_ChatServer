defmodule Chat.Repo.Migrations.CreateChatInfoMessages do
  use Ecto.Migration

  def change do
    create table(:chat_info_messages) do
      timestamps()
      add :body, :string, null: false
      add :type, :string, null: false
    end

  end
end
