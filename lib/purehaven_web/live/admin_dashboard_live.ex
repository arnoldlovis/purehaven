defmodule PurehavenWeb.AdminDashboardLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Production

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :refresh, 30_000) # 30 seconds

    stats = Production.fetch_dashboard_stats()
    chart_data = Production.fetch_chart_data()

    {:ok,
     socket
     |> assign(:stats, stats)
     |> assign(:chart_data, chart_data)
     |> assign(:loading, false)
     |> assign(:show_dropdown, false)} # ✅ Add this here
  end

  @impl true
  def handle_info(:refresh, socket) do
    stats = Production.fetch_dashboard_stats()
    chart_data = Production.fetch_chart_data()

    Process.send_after(self(), :refresh, 30_000)

    socket =
      socket
      |> assign(:stats, stats)
      |> assign(:chart_data, chart_data)
      |> assign(:loading, true)
      |> push_event("update-sales-chart", %{
        labels: chart_data.labels,
        data: chart_data.data
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_dropdown", _, socket) do
    {:noreply, update(socket, :show_dropdown, fn v -> not v end)}
  end

  @impl true
  def handle_event("close_dropdown", _, socket) do
    {:noreply, assign(socket, :show_dropdown, false)}
  end
end
