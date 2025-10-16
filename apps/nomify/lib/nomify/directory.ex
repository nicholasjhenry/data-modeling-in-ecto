defmodule Nomify.Directory do
  @moduledoc """
  The Directory component is responsible for managing people.
  """

  use Nomify, :context


  alias Nomify.Accounts.Scope
  alias Nomify.Directory.Person

  @spec subscribe_people(Scope.t()) :: :ok | {:error, term()}
  def subscribe_people(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:people")
  end

  @spec broadcast_people(Scope.t(), term()) :: :ok | {:error, term()}
  defp broadcast_people(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:people", message)
  end

  @spec list_people :: list(Person.t())
  def list_people do
    Repo.all(Person)
  end

  @spec search_people_by_name(String.t()) :: list(Person.t())
  def search_people_by_name(name) do
    query = from person in Person, where: ilike(person.name, ^"%#{name}%")

    Repo.all(query)
  end

  @spec get_person!(Identifier.t()) :: Person.t()
  def get_person!(id), do: Repo.get!(Person, id)

  @spec create_person(Scope.t()) ::
          {:ok, Person.t()} | {:error, Changeset.t(Person.t())}
  @spec create_person(Scope.t(), Attrs.t()) ::
          {:ok, Person.t()} | {:error, Changeset.t(Person.t())}
  def create_person(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, person = %Person{}} <-
           %Person{}
           |> Person.changeset(attrs)
           |> Repo.insert() do
      broadcast_people(scope, {:created, person})
      {:ok, person}
    end
  end

  @spec update_person(Scope.t(), Person.t(), Attrs.t()) ::
          {:ok, Person.t()} | {:error, Changeset.t(Person.t())}
  def update_person(%Scope{} = scope, %Person{} = person, attrs) do
    with {:ok, person = %Person{}} <-
           person
           |> Person.changeset(attrs)
           |> Repo.update() do
      broadcast_people(scope, {:updated, person})
      {:ok, person}
    end
  end

  @spec delete_person(Scope.t(), Person.t()) ::
          {:ok, Person.t()} | {:error, Changeset.t(Person.t())}
  def delete_person(%Scope{} = scope, %Person{} = person) do
    with {:ok, person = %Person{}} <-
           Repo.delete(person) do
      broadcast_people(scope, {:deleted, person})
      {:ok, person}
    end
  end

  @spec change_person(Person.t()) :: Changeset.t(Person.t())
  @spec change_person(Person.t(), Attrs.t()) :: Changeset.t(Person.t())
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

  @spec test_person(Scope.t()) :: Person.t()
  def test_person(scope) do
    {:ok, person} =
      create_person(scope, %{
        name: "John Smith",
        title: "CTO",
        email: "john@example.com"
      })

    person
  end
end
