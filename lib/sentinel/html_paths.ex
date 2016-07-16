defmodule Sentinel.HtmlPaths do
  @moduledoc """
  Paths used on Sentinel's html controllers
  """

  use Behaviour

  defmacro __using__(_) do
    quote do
      @behaviour Sentinel.HtmlPaths

      def after_sign_in_path(conn, user) do
        "/"
      end

      def after_sign_out_path(conn) do
        Sentinel.RouterHelper.helpers.sessions_path(conn, :new)
      end

      def after_sign_up_path(conn, user) do
        "/"
      end

      defoverridable [
        {:after_sign_in_path, 2},
        {:after_sign_out_path, 1},
        {:after_sign_up_path, 2},
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
end

defmodule Sentinel.HtmlPaths.Default do
  @moduledoc """
  Default implementation of the Sentinel.HtmlPaths
  """
  use Sentinel.HtmlPaths
end
