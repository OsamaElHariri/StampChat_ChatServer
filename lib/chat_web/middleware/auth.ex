defmodule ChatWeb.Plugs.Auth do
  import Plug.Conn

  def init(_), do: %{}

  def call(conn, _params) do
    token = conn |> get_authorization_token()
    verification = ChatWeb.AuthService.verify(token)

    case verification do
      {:ok, user} ->
        conn
        |> assign(:user, user)

      {:error, _} ->
        conn |> send_resp(401, "Not Autherized") |> halt()
    end
  end

  defp get_authorization_token(conn) do
    bearer =
      conn
      |> get_req_header("authorization")
      |> List.first()

    case bearer do
      nil ->
        ""

      _ ->
        bearer
        |> String.replace("Bearer ", "")
    end
  end
end
