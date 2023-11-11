defmodule EctoMultiDemo.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
