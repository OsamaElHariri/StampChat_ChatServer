defmodule ChatWeb.UserView do
  use ChatWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      inserted_at: user.inserted_at,
      friendly_name: user.friendly_name,
      identity: user.identity
    }
  end
end
