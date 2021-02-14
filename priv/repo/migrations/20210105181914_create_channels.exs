defmodule Chat.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      timestamps()

      add :topic, :string
      add :friendly_name, :string
    end

  end
end
