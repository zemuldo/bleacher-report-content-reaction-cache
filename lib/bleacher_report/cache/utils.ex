defmodule BleacherReport.Cache.Utils do
  @lowest_threshold 0
  @default_count_value 0

  @env Application.get_env(:bleacher_report, BleacherReport.Cache)

  def create_table(ets_table_name, opts), do: :ets.new(ets_table_name, _)

  def create_update_action({user_id, content_id, action}) do
    :ets.match(@env[:user_reactions_table], {user_id, content_id, :"$1"})
    |> for_existing_user_reaction(action, content_id)

    case :ets.insert(@env[:user_reactions_table], {user_id, content_id, action}) do
      true -> {:ok, {user_id, content_id, action}}
      _ -> {:error, "Could not add new action"}
    end
  end

  def for_existing_user_reaction([[status]], action, content_id) do
    value = update_value(status, action)
    update_event_reaction(content_id, value)
  end

  def for_existing_user_reaction([], action, content_id) do
    value = update_value(action)
    update_event_reaction(content_id, value)
  end

  def lookup_content_count(content_id) do
    case :ets.lookup(@env[:reactions_counter_table], content_id) do
      [{content_id, count}] -> {:ok, {content_id, count}}
      [] -> {:error, 404, "Content reaction count not found"}
      _ -> {:error, 500, "Error occured"}
    end
  end

  def update_event_reaction(content_id, update_value) when update_value < 0 do
    :ets.update_counter(
      @env[:reactions_counter_table],
      content_id,
      {2, update_value, @lowest_threshold, @default_count_value},
      {update_value, 0, 0}
    )
  end

  def update_event_reaction(content_id, update_value) do
    :ets.update_counter(
      @env[:reactions_counter_table],
      content_id,
      update_value,
      {update_value, @default_count_value}
    )
  end

  defp update_value(:removed), do: 0
  defp update_value(:added), do: 1

  defp update_value(status, action) do
    case {status, action} do
      {:added, :removed} -> -1
      {:removed, :added} -> 1
      {_status, _action} -> 0
    end
  end
end
