defmodule ChatWeb.MessageService do
  import Ecto.Query
  alias Chat.{Repo, Channel, Member, Message}

  def get_channel_messages(channel_id) do
    Repo.all(
      from msg in Message,
        left_join: s in assoc(msg, :stamps),
        where: msg.channel_id == type(^channel_id, :integer),
        order_by: msg.inserted_at,
        preload: [stamps: s]
    )
  end

  def add_message(channel_topic, user_id, body) do
    channel =
      Repo.one(
        from c in Channel,
          where: c.topic == type(^channel_topic, :string)
      )

    member =
      Repo.one(
        from m in Member,
          where: m.user_id == type(^user_id, :integer),
          where: m.channel_id == type(^channel.id, :integer)
      )

    Repo.insert(%Message{
      channel_id: channel.id,
      member_id: member.id,
      body: body
    })
  end

  def notify_members(message_id) do
    message =
      Repo.one(
        from msg in Message,
          join: m in assoc(msg, :member),
          join: u in assoc(m, :user),
          join: c in assoc(msg, :channel),
          where: msg.id == type(^message_id, :integer),
          preload: [member: {m, user: u}, channel: c]
      )

    identities =
      Repo.all(
        from m in Member,
          join: u in assoc(m, :user),
          where: m.channel_id == type(^message.channel_id, :integer),
          where: m.id != type(^message.member_id, :integer),
          select: %{
            member_id: m.id,
            user_id: u.id,
            identity: u.identity
          }
      )
      |> Enum.map(fn user -> user.identity end)

    url = Application.get_env(:notification_server, :url) <> "/notify"

    body =
      Jason.encode!(%{
        "identities" => identities,
        "notification" => %{
          "title" => message.channel.friendly_name,
          "body" => message.member.user.friendly_name <> ": " <> message.body
        }
      })

    headers = %{"Content-Type" => "application/json"}

    HTTPoison.post(url, body, headers)
  end
end