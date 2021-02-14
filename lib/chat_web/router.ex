defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ChatWeb.Plugs.Auth
  end

  scope "/", ChatWeb do
    pipe_through :api

    get "/test", ChannelController, :test
    post "/users", ChannelController, :create_user
  end

  scope "/", ChatWeb do
    pipe_through [:auth, :api]

    get "/channels", ChannelController, :index
    get "/channels/:channel_id/events", ChannelController, :get_events
    post "/channels", ChannelController, :create_channel
    post "/channels/join", ChannelController, :join_channel
    post "/channels/leave", ChannelController, :leave_channel
  end
end
