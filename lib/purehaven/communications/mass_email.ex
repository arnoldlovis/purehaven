defmodule Purehaven.Communications.MassEmail do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :subject, :string
    field :body, :string
  end

  def changeset(mass_email, params \\ %{}) do
    mass_email
    |> cast(params, [:subject, :body])
    |> validate_required([:subject, :body])
  end
end
