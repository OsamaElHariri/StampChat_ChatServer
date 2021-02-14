defmodule Chat.Repo do
  use Ecto.Repo,
    otp_app: :chat,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    env = ChatWeb.EnvironmentService.getConfigs()

    {:ok, Keyword.put(config, :url, env.db_url)}
  end
end
