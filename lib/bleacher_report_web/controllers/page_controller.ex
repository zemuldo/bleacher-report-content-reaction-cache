defmodule BleacherReportWeb.PageController do
  use BleacherReportWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json")
  end
end
