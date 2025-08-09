defmodule Purehaven.Newsletter.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :email, :string
    field :plan, :string, default: "standard"
    field :status, :string, default: "active"
    timestamps()
  end

  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:email, :plan, :status])
    |> validate_required([:email, :plan, :status])
    |> validate_format(:email, ~r/^[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/,
      message: "Invalid email format"
    )
    |> unique_constraint(:email)
  end
end
