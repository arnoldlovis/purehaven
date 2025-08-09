defmodule Purehaven.Production.InputRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "input_records" do
    field :product_name, :string
    field :produced, :integer
    field :sold, :integer
    field :distributed, :integer
    field :stock_remaining, :integer
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(input_record, attrs) do
    input_record
    |> cast(attrs, [:product_name, :produced, :sold, :distributed, :stock_remaining, :date])
    |> validate_required([:product_name, :produced, :sold, :distributed, :stock_remaining, :date])
  end
end
