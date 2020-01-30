defmodule BleacherReport.Auth.ApiUser do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :some_prop, :string
  end

  def changeset(query, params \\ %{}) do
    query
    |> cast(params, [:some_prop])
    |> validate_required([:some_prop])
  end
end
