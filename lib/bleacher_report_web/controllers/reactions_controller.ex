defmodule BleacherReportWeb.ReactionsController do
  use BleacherReportWeb, :controller

  @cache_table_name :user_reactions_cache

  @server_error %{errorType: "SERVER_ERROR", errorMessage: "Server error occurred"}
  @bad_reqeust_message %{errorType: "BAD_REQUEST", errorMessage: "Check your reqeust data"}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_update(conn, %{"content_id" => content_id, "action" => action, "user_id" => user_id}) do
    action_atom = action |> String.to_atom()

    case GenServer.call(
           :user_reactions_cache,
           {:new_user_action, user_id, content_id, action_atom}
         ) do
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
    case GenServer.call(:user_reactions_cache, {:get_content_reaction_count, content_id}) do
      {:ok, {content_id, count}} ->
        conn |> render("data.json", %{data: %{content_id: content_id, count: count}})

      {:error, status, message} ->
        conn
        |> put_status(status)
        |> render("error.json", %{errors: [%{errorType: "BAD_REQUEST", errorMessage: message}]})
    end
  end

  def content_reactions(conn, _),
    do: conn |> put_status(400) |> render("error.json", %{errors: [@bad_reqeust_message]})
end
