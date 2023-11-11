defmodule EctoMultiDemo.Persons do
  @moduledoc """
  The Persons context.
  """

  alias Ecto.Multi
  alias EctoMultiDemo.{Dogs, Repo}
  alias EctoMultiDemo.Persons.Person

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
    |> Repo.insert()
  end

  @doc """
  Creates a person with an associated Dog in a single database transaction.

  Uses `Repo.transaction/0` to ensure that all objects are created in a single transaction.

  ## Examples

      iex> create_person_and_dog_as_transaction()
      {:ok, %Person{}}

  """
  def create_person_and_dog_as_transaction(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, person} <- create_person(attrs),
           # put person_id into attrs for use when creating associated records
           attrs = Map.put(attrs, "person_id", person.id),

           # create associated records
           {:ok, _dog_1} <- Dogs.create_dog(Map.put(attrs, "info", person.name <> " Dog #1")),
           {:ok, _dog_2} <- Dogs.create_dog(Map.put(attrs, "info", person.name <> " Dog #2")) do
        person
      else
        {:error, e} -> Repo.rollback(e)
      end
    end)
  end

  @doc """
  Creates a person with an associated Dog in a single database transaction.

  Uses `Ecto.Multi` to ensure that all objects are created in a single transaction.

  ## Examples

      iex> create_person_and_dog_as_multi()
      {:ok, %Person{}}

  """
  def create_person_and_dog_as_multi(attrs \\ %{}) do
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
