defmodule Purehaven.Repo.Migrations.AddProducedAndDistributedToProductStats do
  use Ecto.Migration

  def change do
    alter table(:product_stats) do
      add :produced, :integer, default: 0
      add :distributed, :integer, default: 0
    end
  end
end
