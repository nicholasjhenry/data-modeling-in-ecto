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

  def load_pallet_on_truck(pallet) do
    pallet
    |> Pallet.load_changeset()
    |> Repo.update()
  end

  alias Examples.DistributionCenter.Case

  def get_case!(id), do: Repo.get!(Case, id)

  def create_case(attrs \\ %{}) do
    %Case{}
    |> Case.changeset(attrs)
    |> Repo.insert()
  end

  def load_case_in_pallet(pallet, case, opts \\ []) do
    pallet
    |> Repo.preload(:cases)
    |> Pallet.calculate_case_count()
    |> Pallet.calculate_actual_weight()
    |> Pallet.put_case_changeset(case, opts)
    |> Repo.update()
  end
end
