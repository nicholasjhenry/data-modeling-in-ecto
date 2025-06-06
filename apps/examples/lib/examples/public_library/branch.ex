defmodule Examples.PublicLibrary.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_branches" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
