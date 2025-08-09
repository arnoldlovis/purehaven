defmodule Purehaven.AdminTest do
  use Purehaven.DataCase

  alias Purehaven.Admin

  describe "dashboards" do
    alias Purehaven.Admin.Dashboard

    import Purehaven.AdminFixtures

    @invalid_attrs %{}

    test "list_dashboards/0 returns all dashboards" do
      dashboard = dashboard_fixture()
      assert Admin.list_dashboards() == [dashboard]
    end

    test "get_dashboard!/1 returns the dashboard with given id" do
      dashboard = dashboard_fixture()
      assert Admin.get_dashboard!(dashboard.id) == dashboard
    end

    test "create_dashboard/1 with valid data creates a dashboard" do
      valid_attrs = %{}

      assert {:ok, %Dashboard{} = dashboard} = Admin.create_dashboard(valid_attrs)
    end

    test "create_dashboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_dashboard(@invalid_attrs)
    end

    test "update_dashboard/2 with valid data updates the dashboard" do
      dashboard = dashboard_fixture()
      update_attrs = %{}

      assert {:ok, %Dashboard{} = dashboard} = Admin.update_dashboard(dashboard, update_attrs)
    end

    test "update_dashboard/2 with invalid data returns error changeset" do
      dashboard = dashboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_dashboard(dashboard, @invalid_attrs)
      assert dashboard == Admin.get_dashboard!(dashboard.id)
    end

    test "delete_dashboard/1 deletes the dashboard" do
      dashboard = dashboard_fixture()
      assert {:ok, %Dashboard{}} = Admin.delete_dashboard(dashboard)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_dashboard!(dashboard.id) end
    end

    test "change_dashboard/1 returns a dashboard changeset" do
      dashboard = dashboard_fixture()
      assert %Ecto.Changeset{} = Admin.change_dashboard(dashboard)
    end
  end
end
