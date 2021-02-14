defmodule Chat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      timestamps()

      add :identity, :string
      add :friendly_name, :string
    end

  end
end
