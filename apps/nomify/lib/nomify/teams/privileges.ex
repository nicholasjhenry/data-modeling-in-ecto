defmodule Nomify.Teams.Privileges do
  @moduledoc """
  Privileges defines team privileges.
  """

  use Bitmask, [
    :delete,
    :nominate
  ]

  @type t :: %Bitmask{bitmask: non_neg_integer(), flags: list(atom())}

  @doc false
  def parse(params) do
    flags = get_all_values() |> Keyword.keys()
    data = flags |> Enum.map(&{&1, nil}) |> Map.new()
    types = flags |> Enum.map(&{&1, :boolean}) |> Map.new()

    changeset = Ecto.Changeset.cast({data, types}, params, Map.keys(types))

    flags =
      changeset.changes
      |> Enum.filter(fn {_key, value} -> value end)
      |> Keyword.keys()

    atom_flags_to_bitmask(flags)
  end
end
