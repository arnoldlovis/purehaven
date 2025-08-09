defmodule Purehaven.ContactMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contact_messages" do
    field :name, :string
    field :email, :string
    field :message, :string

    timestamps()
  end

  def changeset(contact_message, attrs) do
    contact_message
    |> cast(attrs, [:name, :email, :message])
    |> validate_required([:name, :email, :message])
    |> validate_format(:email, ~r/^[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/, message: "Invalid email format")
  end
end
