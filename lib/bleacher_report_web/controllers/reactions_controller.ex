defmodule BleacherReportWeb.ReactionsController do
  use BleacherReportWeb, :controller

  alias BleacherReport.CacheServer

  @cache_table_name :user_reactions_cache

  @server_error %{errorType: "SERVER_ERROR", errorMessage: "Server error occurred"}
  @bad_reqeust_message %{errorType: "BAD_REQUEST", errorMessage: "Check your reqeust data"}

  def new_update(conn, %{"content_id" => content_id, "action" => action, "user_id" => user_id}) do
    action_atom = action |> String.to_atom()

    case CacheServer.new_user_action(user_id, content_id, action_atom) do
      {:ok, _} ->
        conn |> render("data.json", %{data: "ok"})

      {:error, _} ->
        conn
        |> put_status(500)
        |> render("error.json", %{errors: [@server_error]})
    end
  end

  def new_update(conn, _),
    do: conn |> put_status(400) |> render("error.json", %{errors: [@bad_reqeust_message]})

  def content_reactions(conn, %{"content_id" => content_id}) do
    case CacheServer.get_reaction_counts(content_id) do
      {:ok, {content_id, count}} ->
        conn
        |> render("data.json", %{data: %{content_id: content_id, reaction_count: %{fire: count}}})

      {:error, status, message} ->
        conn
        |> put_status(status)
        |> render("error.json", %{
          errors: [%{errorType: status |> error_type_defs(), errorMessage: message}]
        })
    end
  end

  def content_reactions(conn, _),
    do: conn |> put_status(400) |> render("error.json", %{errors: [@bad_reqeust_message]})

  defp error_type_defs(404), do: "NOT_FOUND"
  defp error_type_defs(400), do: "BAD_REQUEST"
  defp error_type_defs(_), do: "SERVER_ERROR"
end
