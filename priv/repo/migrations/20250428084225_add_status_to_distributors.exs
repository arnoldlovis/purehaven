defmodule Purehaven.Repo.Migrations.AddStatusToDistributors do
  use Ecto.Migration

  def change do
    alter table(:distributors) do
      add :status, :string, default: "pending"
    end
  end
end
