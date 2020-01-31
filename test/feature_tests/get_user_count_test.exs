defmodule BleacherReportWeb.FeatureTests.GetUserReactionsCounts do
  use Phoenix.ConnTest, async: true
  # Options, other than file:, are passed directly to `ExUnit`
  use Cabbage.Feature, async: false, file: "get_user_reactions_feature.feature"

  @endpoint BleacherReportWeb.Endpoint

  alias BleacherReport.CacheServer

  test "has a @feature" do
    assert "Getting user reactions count" = @feature.name
  end

  use BleacherReport.Test.TestSetup.ApiToken

  setup state do
    {:ok, state |> Map.put(:load_cache, false)}
  end

  def load_cache(_, false), do: false

  def load_cache(content_id, _) do
    1..1000
    |> Enum.map(fn user_id -> Task.async(fn -> call_cache(user_id, content_id) end) end)
    |> Enum.map(&Task.await/1)
  end

  def call_cache(user_id, content_id) do
    case rem(user_id, 3) do
      0 -> false
      _ -> CacheServer.new_user_actions(user_id, content_id, :added)
    end
  end

  defand ~r/^There is data in the cache$/, _, state do
    {:ok, state |> Map.put(:load_cache, true)}
  end

  defwhen ~r/^I send a GET request to \/api\/reaction_counts\/(?<content_id>[^\" ]+)$/,
          vars,
          state do
    load_cache(fixture(:content_id, vars.content_id |> String.to_atom()), state.load_cache)

    conn =
      build_conn()
      |> put_req_header("api-token", "#{state.api_token}")
      |> put_resp_content_type("application/json")
      |> get("/api/reaction_counts/#{fixture(:content_id, vars.content_id |> String.to_atom())}")

    {:ok, state |> Map.put(:conn, conn)}
  end

  defthen ~r/^I should get a response with status (?<expected_status_code>[^\" ]+)$/,
          vars,
          state do
    assert state.conn.status == vars.expected_status_code |> String.to_integer()
    {:ok, Map.merge(state, vars)}
  end

  defand ~r/^Body to have property data$/, _, state do
    body = json_response(state.conn, 200)
    assert Map.has_key?(body, "data")
    {:ok, Map.merge(state, %{data: body["data"]})}
  end

  defand ~r/^Data to have propert reaction_count$/, _, state do
    assert Map.has_key?(state.data, "reaction_count")
    {:ok, state |> Map.put(:count, state.data["reaction_count"])}
  end

  defand ~r/^Reaction count to be (?<expected_count>[^\" ]+)$/, _vars, state do
    assert state.count["fire"] == 667
    {:ok, state}
  end
end
