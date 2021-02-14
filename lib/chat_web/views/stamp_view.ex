defmodule ChatWeb.StampView do
  use ChatWeb, :view

  def render("stamp.json", %{stamp: stamp}) do
    %{
      id: stamp.id,
      inserted_at: stamp.inserted_at,
      member_id: stamp.member_id,
      word: stamp.word,
      x_pos: stamp.x_pos,
      y_pos: stamp.y_pos,
      word: stamp.word,
      strength: stamp.strength,
      message_id: stamp.message_id
    }
  end
end
