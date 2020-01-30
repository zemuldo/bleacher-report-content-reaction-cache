defmodule BleacherReport.CacheServer do
  use GenServer

  alias BleacherReport.Cache.Utils

  @env Application.get_env(:bleacher_report, BleacherReport.Cache)

  def start_link(opts) do
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  def init(_) do
    Utils.create_table(@env[:user_reactions_table], [:set, :named_table, read_concurrency: true])

    Utils.create_table(@env[:reactions_counter_table], [
      :set,
      :named_table,
      read_concurrency: true
    ])

    {:ok, %{}}
  end

  def handle_call({:new_user_action, user_id, content_id, action}, _, state) do
    {:reply, Utils.create_update_action({user_id, content_id, action}), state}
  end

  def get_reaction_counts(content_id) do
    Utils.lookup_content_count(content_id)
  end
end
