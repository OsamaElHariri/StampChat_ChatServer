defmodule Chat.Repo do
  use Ecto.Repo,
    otp_app: :chat,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    env = ChatWeb.EnvironmentService.getConfigs()

    {:ok,
     Keyword.put(config, :url, String.trim(env.db_url))
     |> Keyword.put(:queue_target, 5000)
     |> Keyword.put(:ssl_opts,
       versions: [:"tlsv1.2"]
     )
     |> Keyword.put(:ssl, true)}
  end
end
