defmodule BleacherReportWeb.FeatureTests.UpdateUserReactionsCounts do
  use Phoenix.ConnTest, async: true
  # Options, other than file:, are passed directly to `ExUnit`
  use Cabbage.Feature, async: false, file: "update_user_reaction.feature"

  @endpoint BleacherReportWeb.Endpoint

  test "has a @feature" do
    assert "Updating user reaction" = @feature.name
  end

  use BleacherReport.Test.TestSetup.ApiToken

  setup state do
    {:ok, state |> Map.put(:load_cache, false)}
  end

  defand ~r/^I send a POST request to \/api\/reaction with (?<user_id>[^\" ]+), (?<content_id>[^\" ]+) and action as added$/, vars, state do
    user_id =  fixture(:user_id, vars.user_id |> String.to_atom())
    content_id =  fixture(:content_id, vars.content_id |> String.to_atom())
    conn =
    build_conn()
    |> put_req_header("api-token", "#{state.api_token}")
    |> put_resp_content_type("application/json")
    |> post("/api/reaction", %{action: "added", user_id: user_id, content_id: content_id})

    {:ok, state |> Map.merge(%{user_id: user_id, content_id: content_id, conn: conn})}
  end

  defthen ~r/^I should get a response with status (?<expected_status_code>[^\" ]+)$/,
          vars,
          state do
    assert state.conn.status == vars.expected_status_code |> String.to_integer()
    {:ok, Map.merge(state, vars)}
  end

  defthen ~r/^I should get a count of 1$/,
          vars,
          state do
            %{"data" => %{"reaction_count" => %{"fire" => fire}} } = json_response(state.conn, 200)
            assert fire == 1
    {:ok, Map.merge(state, vars)}
  end

  defand ~r/^I send a POST request to \/api\/reaction with (?<user_id>[^\" ]+), (?<content_id>[^\" ]+) and action as removed$/, vars, state do
    user_id =  fixture(:user_id, vars.user_id |> String.to_atom())
    content_id =  fixture(:content_id, vars.content_id |> String.to_atom())
    conn =
    build_conn()
    |> put_req_header("api-token", "#{state.api_token}")
    |> put_resp_content_type("application/json")
    |> post("/api/reaction", %{action: "removed", user_id: user_id, content_id: content_id})

    {:ok, state |> Map.merge(%{user_id: user_id, content_id: content_id, conn: conn})}
  end

  defthen ~r/^I should get a count of 0$/,
          vars,
          state do
            %{"data" => %{"reaction_count" => %{"fire" => fire}} } = json_response(state.conn, 200)
            assert fire == 0
    {:ok, Map.merge(state, vars)}
  end

  defwhen ~r/^I send a GET request to \/api\/reaction_counts\/(?<content_id>[^\" ]+)$/,
          vars,
          state do

    conn =
      build_conn()
      |> put_req_header("api-token", "#{state.api_token}")
      |> put_resp_content_type("application/json")
      |> get("/api/reaction_counts/#{fixture(:content_id, vars.content_id |> String.to_atom())}")

    {:ok, state |> Map.put(:conn, conn)}
  end
end
