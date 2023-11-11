defmodule EctoMultiDemo.Dogs.Dog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dogs" do
    # associations
    belongs_to :person, EctoMultiDemo.Persons.Person

    # fields
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(dog \\ %__MODULE__{}, attrs) do
    dog
    |> cast(attrs, [:person_id, :name])
    |> validate_required([:person_id, :name])
  end
end
