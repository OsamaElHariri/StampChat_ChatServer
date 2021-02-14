defmodule Chat.Repo.Migrations.AddTypeToMessagesTable do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :type, :text, default: "chat"
    end
  end
end
