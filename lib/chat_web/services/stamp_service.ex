defmodule ChatWeb.StampService do
  import Ecto.Query
  alias Chat.{Repo, Channel, Member, Stamp}

  def get_channel_stamps(channel_id) do
    Repo.all(
      from stamp in Stamp,
        where: stamp.channel_id == type(^channel_id, :integer),
        order_by: stamp.inserted_at
    )
  end

  def add_stamp(channel_topic, user_id, data) do
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

    Repo.insert(%Stamp{
      channel_id: channel.id,
      member_id: member.id,
      word: data["word"],
      x_pos: data["xPos"],
      y_pos: data["yPos"],
      message_id: data["messageId"],
      strength: data["strength"]
    })
  end
end
