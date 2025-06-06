defmodule Examples.PublicLibrary.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_resources" do
    field :has_fee, :boolean

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:has_fee])
    |> validate_required([:has_fee])
  end
end
