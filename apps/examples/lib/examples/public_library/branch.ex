defmodule Examples.PublicLibrary.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_branches" do
    field :name, :string

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, _branch) do
    resource_hold_changeset
  end
end
