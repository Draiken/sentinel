defmodule Sentinel.Sessions do

  alias Sentinel.Authenticator
  alias Sentinel.UserHelper

  def create(%{"username" => username, "password" => password}) do
    create_session(&Authenticator.authenticate_by_username/2, username, password)
  end

  def create(%{"email" => email, "password" => password}) do
    create_session(&Authenticator.authenticate_by_email/2, email, password)
  end

  def delete(token) do
    Guardian.revoke! token
  end

  defp create_session(method, identifier, password) do
    case method.(identifier, password) do
      {:ok, user} ->
        permissions = UserHelper.model.permissions(user.role)

        case Guardian.encode_and_sign(user, :token, permissions) do
          { :ok, token, claims } ->
            {:ok, user, token, claims}
          { :error, :token_storage_failure } ->
            {:error, "Failed to store session, please try to login again using your new password"}
          error ->
            error
        end
      error ->
        error
    end
  end
end
