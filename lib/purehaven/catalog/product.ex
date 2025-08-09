defmodule Purehaven.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :price, :decimal
    field :long_description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :image, :long_description])
    |> validate_required([:name, :description, :price, :image, :long_description])
  end
end
