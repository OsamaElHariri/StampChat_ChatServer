defmodule Chat.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      timestamps()

      add :channel_id, references(:channels)
      add :user_id, references(:users)
    end

  end
end
