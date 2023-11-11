defmodule EctoMultiDemo.Dogs.Dog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dogs" do
    field :person_id, :id
    field :info, :string

    timestamps()
  end

  @doc false
  def changeset(dog, attrs) do
    dog
    |> cast(attrs, [:info])
    |> validate_required([:info])
  end
end
