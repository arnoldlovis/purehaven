defmodule Purehaven.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :sales, :integer
    field :stock, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :sales, :stock])
    |> validate_required([:name, :sales, :stock])
  end
end
