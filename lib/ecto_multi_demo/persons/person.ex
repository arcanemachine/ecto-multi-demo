defmodule EctoMultiDemo.Persons.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    # associations
    has_many :dogs, EctoMultiDemo.Dogs.Dog

    # fields
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(person \\ %__MODULE__{}, attrs) do
    person
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
