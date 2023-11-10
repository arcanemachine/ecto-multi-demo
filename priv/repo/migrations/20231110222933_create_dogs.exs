defmodule EctoMultiDemo.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs) do
      add :name, :string
      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end

    create index(:dogs, [:person_id])
  end
end
