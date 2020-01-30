defmodule BleacherReport.CacheServer do

    use GenServer

    alias BleacherReport.Cache.Utils

    def start_link(opts) do
      server = Keyword.fetch!(opts, :name)
      GenServer.start_link(__MODULE__, server, opts)
    end
    
    def init(table) do
      Utils.create_table(table, [:named_table, read_concurrency: true])
      {:ok, {table, %{}}}
    end

    def handle_call({:action_counter, content_id, value}, _from, {ets_table_name, _} = state) do
      status = Utils.update_event_reaction(ets_table_name, content_id, value)
      {:reply, status, state}
    end

    def handle_call({:get_content_action_count, content_id}, _from, {ets_table_name, _} = state) do
      data = Utils.lookup_content_count(ets_table_name, content_id)
      {:reply, data, state}
    end

    def handle_cast({user_id, content_id}, {ets_table_name, _} = state) do
      Utils.insert_user_actions(ets_table_name,{user_id, content_id} )
      {:noreply, state}
    end
  end