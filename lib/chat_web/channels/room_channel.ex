defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel

  def join("room:" <> _room_name, _payload, socket) do
    {:ok, socket}
    # if authorized?(payload, socket) do
    #   {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", %{"message" => message}, socket) do
    "room:" <> topic = socket.topic
    {:ok, message} = ChatWeb.MessageService.add_message(topic, socket.assigns.user.id, message)

    spawn(fn -> ChatWeb.MessageService.notify_members(message.id) end)

    broadcast(socket, "shout", %{
      type: "message",
      data: ChatWeb.MessageView.render("message.json", message: message)
    })

    {:noreply, socket}
  end

  def handle_in(
        "stamp",
        %{"word" => word, "xPos" => xPos, "yPos" => yPos, "strength" => strength, "messageId" => message_id},
        socket
      ) do
    "room:" <> topic = socket.topic

    {:ok, stamp} =
      ChatWeb.StampService.add_stamp(topic, socket.assigns.user.id, %{
        "word" => word,
        "xPos" => xPos,
        "yPos" => yPos,
        "messageId" => message_id,
        "strength" => strength
      })

    broadcast(socket, "shout", %{
      type: "stamp",
      data: ChatWeb.StampView.render("stamp.json", stamp: stamp)
    })

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  # defp authorized?(payload, socket) do
  #   IO.puts("SOCKET AUTH")
  #   IO.puts(payload)
  #   IO.puts(socket.params)
  #   true
  # end
end
