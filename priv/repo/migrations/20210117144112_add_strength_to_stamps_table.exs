defmodule Chat.Repo.Migrations.AddStrengthToStampsTable do
  use Ecto.Migration

  def change do
    alter table(:stamps) do
      add :strength, :float, default: 0.0
    end
  end
end
