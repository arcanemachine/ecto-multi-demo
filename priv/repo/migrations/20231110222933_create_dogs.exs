defmodule EctoMultiDemo.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs) do
      # associations
      add :person_id, references(:persons, on_delete: :delete_all), null: false

      # fields
      add :name, :string, null: false

      timestamps()
    end

    create index(:dogs, [:person_id])
  end
end
