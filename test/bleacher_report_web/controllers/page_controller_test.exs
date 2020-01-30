defmodule BleacherReportWeb.PageControllerTest do
  use BleacherReportWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert json_response(conn, 200) == %{"status" => "OK"}
  end
end
