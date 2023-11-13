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
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
