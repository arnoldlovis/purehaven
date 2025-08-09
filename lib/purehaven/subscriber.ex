defmodule Purehaven.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = subscriber, attrs) do
    subscriber
    |> cast(attrs, [:email, :first_name, :last_name])
    |> validate_required([:email, :first_name, :last_name])
    |> validate_format(:email, ~r/^[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/,
      message: "Invalid email format"
    )
    |> unique_constraint(:email)
  end
end
