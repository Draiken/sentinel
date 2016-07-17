defmodule Sentinel.Redirections do
  @moduledoc """
  Paths used on Sentinel's html controllers to redirect requests
  """

  use Behaviour

  defmacro __using__(_) do
    quote do
      @behaviour Sentinel.Redirections

      def after_sign_in_path(_conn, _user) do
        "/"
      end

      def after_sign_out_path(conn) do
        Sentinel.RouterHelper.helpers.sessions_path(conn, :new)
      end

      def after_sign_up_path(_conn, user) do
        "/"
      end

      def after_invited_path(conn, _user) do
        Sentinel.RouterHelper.helpers.user_path(conn, :new)
      end

      def after_confirmation_sent_path(conn, user) do
        Sentinel.RouterHelper.helpers.user_path(conn, :confirmation_instructions)
      end

      defoverridable [
        {:after_sign_in_path, 2},
        {:after_sign_out_path, 1},
        {:after_sign_up_path, 2},
        {:after_invited_path, 2},
        {:after_confirmation_sent_path, 2},
      ]
    end
  end

  @doc """
  Path used to redirect user after a successful sign in
  """
  defcallback after_sign_in_path(
    conn :: Plug.Conn.t,
    user :: term
  )

  @doc """
  Path used to redirect user after a sign out
  """
  defcallback after_sign_out_path(
    conn :: Plug.Conn.t
  )

  @doc """
  Path used to redirect user after a successful sign up
  """
  defcallback after_sign_up_path(
    conn :: Plug.Conn.t,
    user :: term
  )

  @doc """
  Path used to redirect user after a successfully invited
  """
  defcallback after_invited_path(
    conn :: Plug.Conn.t,
    user :: term
  )

  @doc """
  Path used to redirect user after the user confirmation was sent
  """
  defcallback after_confirmation_sent_path(
    conn :: Plug.Conn.t,
    user :: term
  )
end

defmodule Sentinel.Redirections.Default do
  @moduledoc """
  Default implementation of the Sentinel.Redirections
  """
  use Sentinel.Redirections
end
