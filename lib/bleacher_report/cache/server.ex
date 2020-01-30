defmodule BleacherReport.CacheServer do
  use GenServer

  alias BleacherReport.Cache.Utils

  @env Application.get_env(:bleacher_report, BleacherReport.Cache)

  def start_link(opts) do
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  def init(table) do
    Utils.create_table(@env[:user_reactions_table], [:set, :named_table, read_concurrency: true])

    Utils.create_table(@env[:reactions_counter_table], [
      :set,
      :named_table,
      read_concurrency: true
    ])

    {:ok, %{}}
  end

  def handle_call(
        {:new_user_action, user_id, content_id, action},
        _from,
        state
      ) do
    {:reply, Utils.create_update_action({user_id, content_id, action}), state}
  end

  def handle_call({:get_user_action, user_id, content_id}, _from, state) do
    {:reply, Utils.get_user_action(user_id, content_id), state}
  end

  def handle_call({:get_content_reaction_count, content_id}, _from, state) do
    {:reply, Utils.lookup_content_count(content_id), state}
  end

  def handle_cast({user_id, content_id}, state) do
    Utils.insert_user_actions({user_id, content_id})
    {:noreply, state}
  end
end
