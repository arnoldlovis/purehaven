defmodule Purehaven.Repo.Migrations.AddFieldsToInputRecords do
  use Ecto.Migration

  def change do
    alter table(:input_records) do
      add :product_name, :string
      add :produced, :integer, default: 0
      add :sold, :integer, default: 0
      add :distributed, :integer, default: 0
      add :stock_remaining, :integer, default: 0
      add :date, :date
    end
  end
end
