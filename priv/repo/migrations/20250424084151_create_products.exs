defmodule Purehaven.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :sales, :integer
      add :stock, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
