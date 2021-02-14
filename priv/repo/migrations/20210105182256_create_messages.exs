defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      timestamps()

      add :body, :text

      add :member_id, references(:members)
      add :channel_id, references(:channels)
    end

  end
end
