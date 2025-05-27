defmodule ExamplesTest do
  use ExUnit.Case
  doctest Examples

  test "greets the world" do
    assert %Postgrex.Result{num_rows: 1} = Ecto.Adapters.SQL.query!(Examples.Repo, "SELECT 1", [])
    assert Examples.hello() == :world
  end
end
