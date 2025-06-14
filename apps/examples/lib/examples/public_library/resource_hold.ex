defmodule Examples.PublicLibrary.ResourceHold do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.PublicLibrary.Branch
  alias Examples.PublicLibrary.Patron
  alias Examples.PublicLibrary.Resource

  schema "public_library_resource_holds" do
    field :type, Ecto.Enum, values: [:open_ended, :closed_ended]
    field :permit_resource_fees, :boolean, default: false
    field :pickup_day, :string

    belongs_to :branch, Branch
    belongs_to :resource, Resource
    belongs_to :patron, Patron

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(resource_hold, attrs) do
    resource_hold
    |> cast(attrs, [:type, :permit_resource_fees, :pickup_day])
    |> validate_required([:type, :pickup_day])
  end

  # SECTION: Assoc changesets

  def put_branch_changeset(changeset, branch) do
    changeset
    |> put_assoc(:branch, branch)
    |> validate_put_branch(branch)
    |> Branch.validate_put_resource_hold(branch)
  end

  def put_resource_changeset(changeset, resource) do
    changeset
    |> put_assoc(:resource, resource)
    |> validate_put_resource(resource)
    |> Resource.validate_put_resource_hold(resource)
  end

  def put_patron_changeset(changeset, patron) do
    changeset
    |> put_assoc(:patron, patron)
    |> validate_put_patron(patron)
    |> Patron.validate_put_resource_hold(patron)
  end

  # SECTION: Assoc validations

  def validate_put_branch(changeset, _branch) do
    changeset
  end

  def validate_put_resource(changeset, _resource) do
    changeset
  end

  def validate_put_patron(changeset, _patron) do
    changeset
  end
end
