defmodule BleacherReport.Cache.Utils do
  @lowest_threshold 0
  @default_count_value 0

  def create_table(ets_table_name, opts), do: :ets.new(ets_table_name, opts)

  def insert_user_actions(ets_table_name, {user_id, content_id}) do
    :ets.insert(ets_table_name, {user_id, content_id})
  end

  def get_by_content_id(ets_table_name, content_id) do
    :ets.match(ets_table_name, {:"$1", content_id})
  end

  def lookup_content_count(ets_table_name, content_id) do
    case :ets.lookup(ets_table_name, content_id) do
      [{content_id, count}] -> {content_id, count}
      [] -> {:error, "Content reaction count not found"}
      _ -> {:error, "Error occured"}
    end
  end
  
  def update_event_reaction(ets_table_name, content_id, update_value) when update_value < 0 do
    :ets.update_counter(
      ets_table_name,
      content_id,
      {2, update_value, @lowest_threshold, @default_count_value},
      {update_value, 0, 0}
    )
  end

  def update_event_reaction(ets_table_name, content_id, update_value) do
    :ets.update_counter(
      ets_table_name,
      content_id,
      update_value,
      {update_value, @default_count_value}
    )
  end
end
