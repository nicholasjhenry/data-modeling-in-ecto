defmodule Examples.PublicLibrary.ResourceHold do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.PublicLibrary.Branch
  alias Examples.PublicLibrary.Patron
  alias Examples.PublicLibrary.Resource

  schema "public_library_resource_holds" do
    field :type, Ecto.Enum, values: [:open_ended, :closed_ended]
    field :permit_resource_fees, :boolean, default: false
    field :payment, :decimal, default: Decimal.new(0)
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
    |> cast(attrs, [:type, :permit_resource_fees, :pickup_day, :payment])
    |> validate_required([:type, :pickup_day, :payment])
  end

  # SECTION: Assoc changesets

  def put_branch_changeset(changeset, branch) do
    changeset
    |> put_assoc(:branch, branch)
    |> validate_put_branch()
    |> Branch.validate_put_resource_hold(branch)
  end

  def put_resource_changeset(changeset, resource) do
    changeset
    |> put_assoc(:resource, resource)
    |> validate_put_resource()
    |> Resource.validate_put_resource_hold(resource)
  end

  def put_patron_changeset(changeset, patron) do
    changeset
    |> put_assoc(:patron, patron)
    |> validate_put_patron()
    |> Patron.validate_put_resource_hold(patron)
  end

  # SECTION: Assoc validations

  def validate_put_branch(changeset) do
    changeset
    |> Branch.validate_put_resource_hold_conflict()
    |> Patron.validate_put_resource_hold_conflict()
  end

  def validate_put_resource(changeset) do
    changeset
    |> Resource.validate_put_resource_hold_conflict()
    |> Patron.validate_put_resource_hold_conflict()
  end

  def validate_put_patron(changeset) do
    changeset
    |> Patron.validate_put_resource_hold_conflict()
    |> Branch.validate_put_resource_hold_conflict()
    |> Resource.validate_put_resource_hold_conflict()
  end
end
