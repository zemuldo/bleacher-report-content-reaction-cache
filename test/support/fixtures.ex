defmodule BleacherReport.Fixtures do
  alias BleacherReport.Auth.Token
  def fixture(:token, :valid), do: Token.gen_token("say id")
  def fixture(:token, :null), do: nil
  def fixture(:token, :invalid), do: "1234567890-not-valid"

  def fixture(:content_id, :valid_1), do: "56765"
  def fixture(:content_id, :valid_2), do: "55643"
  def fixture(:content_id, :valid_3), do: "34524"
  def fixture(:content_id, :valid_4), do: "23232"
  def fixture(:content_id, :valid_5), do: "95777"
  def fixture(:content_id, :unknown), do: "unknown"
end
