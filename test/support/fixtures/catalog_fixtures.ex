defmodule Purehaven.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Purehaven.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image: "some image",
        long_description: "some long_description",
        name: "some name",
        price: "120.5"
      })
      |> Purehaven.Catalog.create_product()

    product
  end
end
