# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :chat, Chat.Repo,
  # ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# config :chat, ChatWeb.Endpoint,
#   http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
#   secret_key_base: "abc123123"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :chat, ChatWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
