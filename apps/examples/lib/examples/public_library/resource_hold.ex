defmodule Examples.PublicLibrary.ResourceHold do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.PublicLibrary.Branch

  schema "public_library_resource_holds" do
    field :type, Ecto.Enum, values: [:open_ended, :closed_ended]
    field :permit_resource_fees, :boolean, default: false

    belongs_to :branch, Branch

    timestamps()
  end

  @doc false
  def changeset(resource_hold, attrs) do
    resource_hold
    |> cast(attrs, [:type, :permit_resource_fees])
    |> validate_required([:type, :permit_resource_fees])
  end

  def put_branch_changeset(changeset, branch) do
    changeset
    |> put_assoc(:branch, branch)
    |> validate_put_branch(branch)
  end

  def validate_put_branch(changeset, _branch) do
    changeset
  end
end
