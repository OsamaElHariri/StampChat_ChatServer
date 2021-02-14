defmodule Chat.Repo.Migrations.AddIsParticipantToMembersTable do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :is_participant, :boolean, default: true
    end
  end
end
