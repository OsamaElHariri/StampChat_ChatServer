defmodule ChatWeb.ChannelView do
  use ChatWeb, :view

  def render("messages_and_members_data.json", data) do
    %{
      data: render(ChatWeb.MessageView, "messages_and_members.json", data)
    }
  end

  def render("channels_data.json", %{channels: channels}) do
    %{data: render_many(channels, ChatWeb.ChannelView, "channel.json")}
  end

  def render("channels.json", %{channels: channels}) do
    render_many(channels, ChatWeb.ChannelView, "channel.json")
  end

  def render("channel_data.json", %{channel: channel}) do
    %{data: render_one(channel, ChatWeb.ChannelView, "channel.json")}
  end

  def render("channel.json", %{channel: channel}) do
    %{
      id: channel.id,
      inserted_at: channel.inserted_at,
      friendly_name: channel.friendly_name,
      topic: channel.topic
    }
    |> add_members(channel)
    |> add_last_message(channel)
  end

  defp add_members(channel_map, channel) do
    if Ecto.assoc_loaded?(channel.members) do
      channel_map
      |> Map.put(:members, render_many(channel.members, ChatWeb.MemberView, "member.json"))
    else
      channel_map
    end
  end

  defp add_last_message(channel_map, channel) do
    if Ecto.assoc_loaded?(channel.messages) && length(channel.messages) > 0 do
      channel_map
      |> Map.put(
        :last_message,
        render_one(List.last(channel.messages), ChatWeb.MessageView, "message.json")
        |> add_user_to_last_message(channel)
      )
    else
      channel_map
    end
  end

  defp add_user_to_last_message(last_message_map, channel) do
    unless Ecto.assoc_loaded?(channel.members) do
      last_message_map
    else
      case Enum.find(channel.members, nil, fn m ->
             Map.get(last_message_map, :member_id) == m.id
           end) do
        nil ->
          last_message_map

        member ->
          last_message_map
          |> Map.put(:member, render_one(member, ChatWeb.MemberView, "member.json"))
      end
    end
  end
end
