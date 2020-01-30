defmodule BleacherReportWeb.PageView do
  use BleacherReportWeb, :view

  def render("index.json", _) do
    %{status: "OK"}
  end
end
