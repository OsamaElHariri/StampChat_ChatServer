defmodule ChatWeb.MemberView do
  use ChatWeb, :view

  def render("members.json", %{members: members}) do
    render_many(members, ChatWeb.MemberView, "member.json")
  end

  def render("member.json", %{member: member}) do
    member_map = %{
      id: member.id,
      inserted_at: member.inserted_at
    }

    if Ecto.assoc_loaded?(member.user) do
      member_map
      |> Map.put(:user, render_one(member.user, ChatWeb.UserView, "user.json"))
    else
      member_map
    end
  end
end
