defmodule Examples.OfficeSupplyStore do
  @moduledoc """
  The OfficeSupplyStore context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.OfficeSupplyStore.Person

  def get_person!(id), do: Repo.get!(Person, id)

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end
end
