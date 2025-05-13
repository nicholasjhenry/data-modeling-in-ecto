defmodule Nomify.Directory.Person do
  @moduledoc """
  A Person is an individual entity representing a human being playing multiple roles in the system (e.g. team member).
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
          id: integer(),
          title: String.t(),
          name: String.t(),
          email: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
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
