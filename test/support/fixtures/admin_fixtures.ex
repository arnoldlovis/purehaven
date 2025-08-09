defmodule Purehaven.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Purehaven.Admin` context.
  """

  @doc """
  Generate a dashboard.
  """
  def dashboard_fixture(attrs \\ %{}) do
    {:ok, dashboard} =
      attrs
      |> Enum.into(%{

      })
      |> Purehaven.Admin.create_dashboard()

    dashboard
  end
end
