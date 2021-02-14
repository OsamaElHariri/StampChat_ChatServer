defmodule Chat.Repo.Migrations.CreateStamps do
  use Ecto.Migration

  def change do
    create table(:stamps) do
      timestamps()

      add :word, :string, null: false
      add :x_pos, :float, null: false
      add :y_pos, :float, null: false

      add :member_id, references(:members), null: false
      add :channel_id, references(:channels), null: false
    end

  end
end
