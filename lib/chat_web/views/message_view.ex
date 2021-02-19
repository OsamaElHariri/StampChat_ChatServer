defmodule ChatWeb.MessageView do
  use ChatWeb, :view

  def render("messages_and_members.json", %{
        messages: messages,
        members: members,
        is_last_message: is_last_message
      }) do
    %{
      is_last_message: is_last_message,
      messages: render_many(messages, ChatWeb.MessageView, "message.json"),
      members: render_many(members, ChatWeb.MemberView, "member.json")
    }
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      channel_id: message.channel_id,
      member_id: message.member_id,
      type: message.type,
      body: message.body
    }
    |> add_stamps(message)
  end

  defp add_stamps(message_map, message) do
    if Ecto.assoc_loaded?(message.stamps) do
      message_map
      |> Map.put(:stamps, render_many(message.stamps, ChatWeb.StampView, "stamp.json"))
    else
      message_map
    end
  end
end
