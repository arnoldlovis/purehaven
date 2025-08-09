defmodule Purehaven.Distributor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "distributors" do
    field :first_name, :string
    field :last_name, :string
    field :company, :string
    field :email, :string
    field :phone, :string
    field :location, :string
    field :message, :string
    field :interests, :string
    field :status, :string, default: "Pending"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(distributor, attrs) do
    distributor
    |> cast(attrs, [:first_name, :last_name, :company, :email, :phone, :location, :message, :interests, :status])
    |> validate_required([:first_name, :last_name, :company, :email, :phone, :location, :message, :interests])
  end
end
