defmodule BleacherReport.Auth.ApiUserPlug do
  import Plug.Conn
  use Phoenix.Controller


  alias BleacherReport.Auth.Token

  def init(options), do: options

  def call(conn, _) do
    conn |> check_token()
  end

  defp check_token(conn) do
    case get_req_header(conn, "api-token") do
      [token | _] ->
        conn |> validate_token(token)

      _ ->
        conn |> terminate()
    end
  end

  defp validate_token(conn, token) do
    case Token.check_token(token) do
      {:ok, data} -> conn |> assign(:api_user, data)
      _ -> conn |> terminate()
    end
  end

  defp terminate(conn) do
    conn
    |> put_status(401)
    |> json(%{errors: [%{errorType: "AUTH_ERROR", errorMessage: "Not authorized!"}]})
    |> halt
  end
end
