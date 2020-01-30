defmodule BleacherReportWeb.UserActionsController do
    use BleacherReportWeb, :controller
  
    def index(conn, _params) do
      render(conn, "index.html")
    end
  end
  