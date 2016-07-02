defmodule Sentinel.Controllers.Sessions do
  use Phoenix.Controller
  alias Sentinel.Util
  alias Sentinel.Sessions

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureAuthenticated, %{ handler: Application.get_env(:sentinel, :auth_handler) || Sentinel.AuthHandler } when action in [:delete]

  @doc """
  Log in as an existing user.
  Parameter are "email" and "password".
  Responds with status 200 and {token: token} if credentials were correct.
  Responds with status 401 and {errors: error_message} otherwise.
  """
  def create(conn, params) do
    case Sessions.create(params) do
      {:ok, user, token, _claims} ->
        json conn, %{token: token}
      {:error, reason} ->
        Util.send_error(conn, reason, 401)
    end
  end

  @doc """
  Destroy the active session.
  Will delete the authentication token from the user table.
  Responds with status 200 if no error occured.
  """
  def delete(conn, _params) do
    token = Plug.Conn.get_req_header(conn, "authorization") |> List.first

    case Sessions.delete(token) do
      :ok ->
        json conn, :ok
      { :error, :could_not_revoke_token } ->
        Util.send_error(conn, %{error: "Could not revoke the session token"}, 422)
      { :error, error } ->
        Util.send_error(conn, error, 422)
    end
  end
end
