defmodule Purehaven.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :name, :string
    field :review, :string
    field :rating, :integer

    timestamps()
  end

  def changeset(review, attrs) do
    review
    |> cast(attrs, [:name, :review, :rating])
    |> validate_required([:name, :review, :rating])
    |> validate_inclusion(:rating, 1..5)
  end
end
