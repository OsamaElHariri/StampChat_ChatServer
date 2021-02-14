defmodule Chat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Chat.Repo,
      ChatWeb.Endpoint
    ]

    env = ChatWeb.EnvironmentService.getConfigs()

    Application.put_env(
      :notification_server,
      :url,
      "http://" <> env.notification_host <> ":" <> env.notification_port
    )

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
