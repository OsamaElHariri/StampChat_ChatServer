defmodule Chat.Repo.Migrations.AddMessageIdToStamps do
  use Ecto.Migration

  def change do
    alter table(:stamps) do
      add :message_id, references(:messages), null: false
    end
  end
end
