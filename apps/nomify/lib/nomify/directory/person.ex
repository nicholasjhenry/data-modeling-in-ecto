defmodule Nomify.Directory.Person do
  @moduledoc """
  A Person is record of an individual entity playing multiple roles in the system.
  """

  use Nomify, :record

  alias Nomify.Util.EmailAddress

  @typedoc """
  ## Fields

  A Person has these fields:

  - `title` (descriptive): The title or honorific of the person.
  - `name` (descriptive): The full name of the person.
  - `email` (descriptive): The email address of the person.
  """

  @type t :: %__MODULE__{
          id: integer() | nil,
          title: String.t() | nil,
          name: String.t() | nil,
          email: String.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "directory_people" do
    # SECTION: Fields
    field :title, :string
    field :name, :string
    field :email, :string

    timestamps()
  end

  # SECTION: Field Changesets

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:title, :name, :email])
    |> validate_required([:title, :name])
  end

  @doc false
  def valid_email?(person) do
    match?({:ok, _email}, EmailAddress.parse(person.email))
  end
end
