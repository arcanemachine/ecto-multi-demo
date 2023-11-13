defmodule EctoMultiDemo.Persons do
  @moduledoc """
  The Persons context.
  """

  import Ecto.Query

  alias Ecto.{Changeset, Multi}
  alias EctoMultiDemo.Repo
  alias EctoMultiDemo.Persons.Person

  @hardcoded_trusted_attrs %{
    name: "Alice",
    dogs: [
      %{name: "Annie"},
      %{name: "Betty"}
    ]
  }

  @hardcoded_untrusted_attrs %{
    "name" => "Alice",
    "dogs" => [
      %{"name" => "Annie"},
      %{"name" => "Betty"}
    ]
  }

  def get_hardcoded_trusted_attrs(), do: @hardcoded_trusted_attrs
  def get_hardcoded_untrusted_attrs(), do: @hardcoded_untrusted_attrs

  # composable queries
  def get_person_with_all_associations(person_id) do
    Repo.get(Person |> person_with_all_associations, person_id)
  end

  def person_with_all_associations(queryable), do: queryable |> preload([:dogs])

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons do
    Repo.all(Person)
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Changeset.cast_assoc(:dogs)
    |> Repo.insert()
  end

  @doc """
  Creates a person with associated Dogs.

  ## Examples

      iex> create_person_and_dogs()
      {:ok, %Person{}}

  """
  def create_person_and_dogs(attrs \\ @hardcoded_untrusted_attrs) do
    %Person{}
    |> change_person(attrs)
    |> Changeset.cast_assoc(:dogs)
    |> Repo.insert()
  end

  def create_person_and_dogs_with_untrusted_data(attrs \\ @hardcoded_untrusted_attrs),
    do: create_person_and_dogs(attrs)

  def create_person_and_dogs_with_trusted_data(attrs \\ @hardcoded_trusted_attrs) do
    %Person{}
    |> change_person(attrs)
    |> Changeset.put_assoc(:dogs, attrs[:dogs] || [])
    |> Repo.insert()
  end

  @doc """
  Creates a person with an associated Dog in a single database transaction.

  Uses `Ecto.Multi` to ensure that all objects are created in a single transaction.

  ## Examples

      iex> create_person_and_dogs_as_multi()
      {:ok, %Person{}}

  """
  def create_person_and_dogs_as_multi(attrs \\ @hardcoded_untrusted_attrs) do
    Multi.new()
    |> Multi.insert(:person, change_person(%Person{}, attrs))
    |> Multi.merge(fn %{person: person} ->
      # create associated records
      Multi.new()
      |> Multi.insert(:dog_1, Ecto.build_assoc(person, :dogs, name: person.name <> " Dog #1"))
      |> Multi.insert(:dog_2, Ecto.build_assoc(person, :dogs, name: person.name <> " Dog #2"))
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end
end
