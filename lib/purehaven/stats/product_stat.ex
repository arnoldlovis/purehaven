defmodule Purehaven.Stats.ProductStat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_stats" do
    field :produced, :integer
    field :distributed, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product_stat, attrs) do
    product_stat
    |> cast(attrs, [:produced, :distributed])
    |> validate_required([:produced, :distributed])
  end
end
