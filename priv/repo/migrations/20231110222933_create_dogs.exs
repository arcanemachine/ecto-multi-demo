defmodule EctoMultiDemo.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs) do
      add :person_id, references(:persons, on_delete: :nothing)
      add :info, :string

      timestamps()
    end

    create index(:dogs, [:person_id])
  end
end
