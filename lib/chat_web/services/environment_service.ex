defmodule ChatWeb.EnvironmentService do
  def getConfigs() do
    env =
      Vapor.load!([
        %Vapor.Provider.Env{
          bindings: [
            {:env, "MIX_ENV", default: "dev"}
          ]
        }
      ])

    provider =
      case env.env do
        "prod" ->
          %Vapor.Provider.Env{
            bindings: [
              db_url: "DB_URL",
              port: "PORT",
              secret_key_base: "SECRET_KEY_BASE",
              notification_port: "STAMP_CHAT_NOTIFICATIONS_SERVICE_PORT",
              notification_host: "STAMP_CHAT_NOTIFICATIONS_SERVICE_HOST"
            ]
          }

        _ ->
          %Vapor.Provider.File{
            path: "config.yaml",
            bindings: [
              db_url: "db_url",
              port: "port",
              secret_key_base: "secret_key_base",
              notification_port: "notification_server_port",
              notification_host: "notification_server_host"
            ]
          }
      end

      Vapor.load!([provider])
  end
end
