defmodule BleacherReport.Auth.Token do
  import Phoenix.Token

  @env Application.get_env(:bleacher_report, BleacherReportWeb.Endpoint)

  def gen_token(some_value) do
    sign(BleacherReportWeb.Endpoint, @env[:api_auth_salt], some_value)
  end

  def check_token(token) do
    verify(BleacherReportWeb.Endpoint, @env[:api_auth_salt], token, max_age: :infinity)
  end
end
