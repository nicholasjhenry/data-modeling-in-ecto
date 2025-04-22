defmodule Nomify.Teams.PrivilegesTest do
  use ExUnit.Case

  alias Nomify.Teams.Privileges

  test "parses params" do
    assert Privileges.parse(%{"delete" => "false", "nominate" => "false"}) == %Bitmask{
             bitmask: 0,
             flags: []
           }

    assert Privileges.parse(%{"delete" => "true", "nominate" => "false"}) == %Bitmask{
             bitmask: 1,
             flags: [:delete]
           }

    assert Privileges.parse(%{"delete" => "true", "nominate" => "true"}) == %Bitmask{
             bitmask: 3,
             flags: [:delete, :nominate]
           }
  end
end
