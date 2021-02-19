defmodule ChatWeb.ChannelService do
  import Ecto.Query
  alias Chat.{Repo, Channel, Member, User, Message}
  alias ChatWeb.ChatInfoService

  def get_channels(user_id) do
    Repo.all(
      from c in Channel,
        as: :channel,
        join: msg in assoc(c, :messages),
        inner_lateral_join:
          last_message in subquery(
            from Message,
              where: [channel_id: parent_as(:channel).id],
              order_by: [desc: :inserted_at],
              limit: 1,
              select: [:id]
          ),
        on: last_message.id == msg.id,
        join: channel_member in Member,
        on: c.id == channel_member.channel_id,
        join: m in Member,
        on: c.id == m.channel_id,
        join: u in User,
        on: u.id == m.user_id,
        where: channel_member.user_id == type(^user_id, :integer),
        where: channel_member.is_participant == true,
        preload: [members: {m, user: u}, messages: msg]
    ) || []
  end

  def get_members(channel_id) do
    Repo.all(
      from m in Member,
        join: usr in assoc(m, :user),
        on: usr.id == m.user_id,
        where: m.channel_id == type(^channel_id, :integer),
        preload: [user: usr]
    )
  end

  def create_channel(channel_name, user_id) do
    user =
      Repo.one(
        from u in User,
          where: u.id == type(^user_id, :integer)
      )

    channel_topic =
      String.downcase(channel_name)
      |> String.replace(~r/(\s+)|(:)/, "_")

    {:ok, channel} =
      Repo.insert(
        %Channel{
          friendly_name: channel_name,
          topic: (channel_topic <> "_" <> random_string(8)) |> String.downcase()
        },
        returning: true
      )

    {:ok, member} =
      Repo.insert(%Member{
        channel_id: channel.id,
        user_id: user_id
      })

    {:ok, _message} =
      Repo.insert(%Message{
        channel_id: channel.id,
        member_id: member.id,
        body:
          ChatInfoService.get_random_info_text("create_chat", %{
            "name" => user.friendly_name
          }),
        type: "chat_info"
      })

    channel
  end

  # https://stackoverflow.com/questions/32001606/how-to-generate-a-random-url-safe-string-with-elixir
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def join_channel(user_id, topic) do
    user =
      Repo.one(
        from u in User,
          where: u.id == type(^user_id, :integer)
      )

    channel =
      Repo.one(
        from c in Channel,
          where: c.topic == type(^topic, :string)
      )

    channel_id = channel.id

    member =
      Repo.one(
        from m in Member,
          where: m.user_id == type(^user.id, :integer),
          where: m.channel_id == type(^channel_id, :integer)
      )

    is_participant = member != nil && member.is_participant

    member =
      if member == nil do
        {:ok, m} =
          Repo.insert(
            %Member{
              channel_id: channel_id,
              user_id: user.id
            },
            returning: true
          )

        m
      else
        member
        |> Ecto.Changeset.change(%{is_participant: true})
        |> Repo.update()

        member
      end

    if !is_participant do
      {:ok, message} =
        Repo.insert(%Message{
          channel_id: channel.id,
          member_id: member.id,
          body:
            ChatInfoService.get_random_info_text("join_chat", %{
              "name" => user.friendly_name
            }),
          type: "chat_info"
        })

      ChatWeb.Endpoint.broadcast("room:" <> topic, "shout", %{
        type: "message",
        data: ChatWeb.MessageView.render("message.json", message: message)
      })
    end
  end

  def leave_channel(user_id, channel_id) do
    user =
      Repo.one(
        from u in User,
          where: u.id == type(^user_id, :integer)
      )

    channel =
      Repo.one(
        from c in Channel,
          where: c.id == type(^channel_id, :integer)
      )

    member =
      Repo.one(
        from m in Member,
          where: m.user_id == type(^user.id, :integer),
          where: m.channel_id == type(^channel.id, :integer)
      )

    if member != nil do
      if member.is_participant do
        {:ok, message} =
          Repo.insert(
            %Message{
              channel_id: channel.id,
              member_id: member.id,
              body:
                ChatInfoService.get_random_info_text("leave_chat", %{
                  "name" => user.friendly_name
                }),
              type: "chat_info"
            },
            returning: true
          )

        ChatWeb.Endpoint.broadcast("room:" <> channel.topic, "shout", %{
          type: "message",
          data: ChatWeb.MessageView.render("message.json", message: message)
        })
      end

      member
      |> Ecto.Changeset.change(%{is_participant: false})
      |> Repo.update()
    end
  end
end
