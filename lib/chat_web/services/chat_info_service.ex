defmodule ChatWeb.ChatInfoService do
  import Ecto.Query
  alias Chat.{Repo, ChatInfoMessage}

  def add_text(type, body) do
    Repo.insert(%ChatInfoMessage{
      type: type,
      body: body
    })
  end

  def get_random_info_text(type, text_data) do
    (get_random_info_text(type) || get_default(type))
    |> apply_text_data(text_data)
  end

  defp get_random_info_text(type) do
    msg =
      Repo.one(
        from c in ChatInfoMessage,
          where: c.type == type(^type, :string),
          order_by: fragment("RANDOM()"),
          limit: 1
      )

    case msg do
      nil ->
        nil

      _ ->
        msg.body
    end
  end

  defp get_default("join_chat") do
    "${name} has joined the chat"
  end

  defp get_default("leave_chat") do
    "${name} has left the chat"
  end

  defp get_default("create_chat") do
    "${name} started the chat"
  end

  # replace the string ${x} with text_data[x]
  # example:
  # apply_text_data("Hello ${name}, how are you?", %{"name" => "Pancake"})
  # returns: "Hello Pancake, how are you?"
  defp apply_text_data(text, text_data) do
    Regex.replace(~r/\${(\w+)}/, text, fn _, match ->
      if Map.has_key?(text_data, match) do
        text_data[match]
      else
        match
      end
    end)
  end

  def seed_msgs() do
    add_text("join_chat", "*${name}* just walked in")
    add_text("join_chat", "Welcome aboard, *${name}*")
    add_text("join_chat", "Change the subject! *${name}* just joined")
    add_text("join_chat", "Look who it is, it's *${name}*!")
    add_text("join_chat", "Make way, make way, it's *${name}*")
    add_text("join_chat", "Make some noise for *${name}*!")
    add_text("join_chat", "*${name}* just graced us with their presence")

    add_text("leave_chat", "*${name}* is outta here")
    add_text("leave_chat", "*${name}* just walked out")
    add_text("leave_chat", "*${name}* left. I miss them already")
    add_text("leave_chat", "Farewell, *${name}*")
    add_text("leave_chat", "*${name}* has abandoned the ship")
    add_text("leave_chat", "*${name}* just graced us with their absence")

    add_text("create_chat", "*${name}* willed this chat into being")
    add_text("create_chat", "*${name}* is ready to discuss serious stuff")
    add_text("create_chat", "This here chat belongs to *${name}*")
  end
end
