defmodule Examples.PublicLibrary.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_resources" do
    field :has_fee, :boolean

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:has_fee])
    |> validate_required([:has_fee])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, _resource) do
    resource_hold_changeset
  end
end
