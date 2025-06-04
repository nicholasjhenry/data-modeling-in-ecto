defmodule Examples.DistributionCenter do
  @moduledoc """
  The DistributionCenter context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.DistributionCenter.Pallet

  def get_pallet!(id), do: Repo.get!(Pallet, id)

  def create_pallet(attrs \\ %{}) do
    %Pallet{}
    |> Pallet.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.DistributionCenter.Case

  def get_case!(id), do: Repo.get!(Case, id)

  def create_case(attrs \\ %{}) do
    %Case{}
    |> Case.changeset(attrs)
    |> Repo.insert()
  end

  def load_case_in_pallet(pallet, case) do
    pallet
    |> Repo.preload(:cases)
    |> Pallet.put_case_changeset(case)
    |> Repo.update()
  end
end
