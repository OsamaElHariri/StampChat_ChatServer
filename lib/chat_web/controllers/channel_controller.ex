defmodule ChatWeb.ChannelController do
  use ChatWeb, :controller

  def test(conn, _params) do
    json(conn, %{
      "test" => "success"
    })
  end

  def index(conn, _params) do
    render(conn, "channels_data.json",
      channels: ChatWeb.ChannelService.get_channels(conn.assigns[:user].id)
    )
  end

  def create_user(conn, %{"name" => name, "identity" => identity}) do
    json(conn, %{
      "user" => ChatWeb.UserService.add_user(identity, name)
    })
  end

  def create_channel(conn, %{"channel_name" => channel_name}) do
    render(conn, "channel_data.json",
      channel: ChatWeb.ChannelService.create_channel(channel_name, conn.assigns[:user].id)
    )
  end

  def join_channel(conn, %{"topic" => topic}) do
    ChatWeb.ChannelService.join_channel(conn.assigns[:user].id, topic)

    json(conn, %{
      "success" => true
    })
  end

  def leave_channel(conn, %{"channel_id" => channel_id}) do
    ChatWeb.ChannelService.leave_channel(conn.assigns[:user].id, channel_id)

    json(conn, %{
      "success" => true
    })
  end

  def get_events(conn, %{"channel_id" => channel_id, "last_message_id" => last_message_id}) do
    {is_last_message, messages} =
      ChatWeb.MessageService.get_channel_messages(channel_id, last_message_id)

    render(conn, "messages_and_members_data.json",
      is_last_message: is_last_message,
      messages: messages,
      members: ChatWeb.ChannelService.get_members(channel_id)
    )
  end
end
