defmodule Nomify.Directory do
  @moduledoc """
  The Directory component is responsible for managing people.
  """

  import Ecto.Query, warn: false
  alias Nomify.Repo

  alias Nomify.Accounts
  alias Nomify.Accounts.Scope
  alias Nomify.Directory.Person

  def subscribe_people(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:people")
  end

  defp broadcast_people(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:people", message)
  end

  def list_people do
    Repo.all(Person)
  end

  def search_people_by_name(name) do
    query = from person in Person, where: ilike(person.name, ^"%#{name}%")

    Repo.all(query)
  end

  def get_person!(id), do: Repo.get!(Person, id)

  def create_person(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, person = %Person{}} <-
           %Person{}
           |> Person.changeset(attrs)
           |> Repo.insert() do
      broadcast_people(scope, {:created, person})
      {:ok, person}
    end
  end

  def update_person(%Scope{} = scope, %Person{} = person, attrs) do
    with {:ok, person = %Person{}} <-
           person
           |> Person.changeset(attrs)
           |> Repo.update() do
      broadcast_people(scope, {:updated, person})
      {:ok, person}
    end
  end

  def delete_person(%Scope{} = scope, %Person{} = person) do
    with {:ok, person = %Person{}} <-
           Repo.delete(person) do
      broadcast_people(scope, {:deleted, person})
      {:ok, person}
    end
  end

  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

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
