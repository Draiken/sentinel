defmodule Sentinel.Controllers.Html.Sessions do
  use Phoenix.Controller
  alias Sentinel.Authenticator

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated, %{ handler: Application.get_env(:sentinel, :auth_handler) || Sentinel.AuthHandler } when action in [:delete]
  plug Guardian.Plug.LoadResource

  def new(conn, _params) do
    changeset = Sentinel.Session.changeset(%Sentinel.Session{})

    conn
    |> put_status(:ok)
    |> render(Sentinel.SessionView, "new.html", changeset: changeset)
  end

  @doc """
  Log in as an existing user.
  Parameter are "username" and "password".
  """
  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Authenticator.authenticate_by_username(username, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: html_paths.after_sign_in_path(conn, user))
      {:error, errors} ->
        conn
        |> put_flash(:error, errors.base)
        |> redirect(to: Sentinel.RouterHelper.helpers.sessions_path(conn, :new))
    end
  end

  @doc """
  Log in as an existing user.
  Parameter are "email" and "password".
  """
  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Authenticator.authenticate_by_email(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: html_paths.after_sign_in_path(conn, user))
      {:error, errors} ->
        conn
        |> put_flash(:error, errors.base)
        |> redirect(to: Sentinel.RouterHelper.helpers.sessions_path(conn, :new))
    end
  end

  @doc """
  Destroy the active session.
  """
  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: html_paths.after_sign_out_path(conn))
  end

  defp html_paths do
    Application.get_env(:sentinel, :html_paths, Sentinel.HtmlPaths.Default)
  end
end
