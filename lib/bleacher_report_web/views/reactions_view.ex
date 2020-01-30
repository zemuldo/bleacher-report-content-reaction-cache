defmodule BleacherReportWeb.ReactionsView do
  use BleacherReportWeb, :view

  def render("index.json", _) do
    %{status: "OK"}
  end

  def render("data.json", %{data: data}) do
    %{data: data}
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
