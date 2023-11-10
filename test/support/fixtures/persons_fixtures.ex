defmodule EctoMultiDemo.PersonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EctoMultiDemo.Persons` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> EctoMultiDemo.Persons.create_person()

    person
  end
end
