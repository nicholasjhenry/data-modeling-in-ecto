defmodule Examples.PublicLibrary.ResourceHold do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_resource_holds" do
    field :type, Ecto.Enum, values: [:open_ended, :closed_ended]
    field :permit_resource_fees, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(resource_hold, attrs) do
    resource_hold
    |> cast(attrs, [:type, :permit_resource_fees])
    |> validate_required([:type, :permit_resource_fees])
  end
end
