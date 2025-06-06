defmodule Examples.PublicLibrary.ResourceHold do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.PublicLibrary.Branch
  alias Examples.PublicLibrary.Resource

  schema "public_library_resource_holds" do
    field :type, Ecto.Enum, values: [:open_ended, :closed_ended]
    field :permit_resource_fees, :boolean, default: false

    belongs_to :branch, Branch
    belongs_to :resource, Resource

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(resource_hold, attrs) do
    resource_hold
    |> cast(attrs, [:type, :permit_resource_fees])
    |> validate_required([:type, :permit_resource_fees])
  end

  # SECTION: Assoc changesets

  def put_branch_changeset(changeset, branch) do
    changeset
    |> put_assoc(:branch, branch)
    |> validate_put_branch(branch)
  end

  def put_resource_changeset(changeset, resource) do
    changeset
    |> put_assoc(:resource, resource)
    |> validate_put_resource(resource)
  end

  # SECTION: Assoc validations

  def validate_put_branch(changeset, _branch) do
    changeset
  end

  def validate_put_resource(changeset, _resource) do
    changeset
  end
end
