defmodule BleacherReport.Test.TestSetup.ApiToken do
  defmacro __using__(_) do
    quote do
      import BleacherReport.Fixtures

      defgiven ~r/^I have a valid api key$/, _, state do
        {:ok, state |> Map.merge(%{api_token: fixture(:token, :valid)})}
      end

      defgiven ~r/^I have (?<api_key_type>[^\" ]+) api key$/, vars, state do
        {:ok,
         state |> Map.merge(%{api_token: fixture(:token, String.to_atom(vars.api_key_type))})}
      end
    end
  end
end
