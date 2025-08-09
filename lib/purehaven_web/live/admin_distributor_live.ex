defmodule PurehavenWeb.AdminDistributorLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Distributors

  @impl true
  def mount(_params, _session, socket) do
    params = %{"query" => "", "page" => 1}
    distributors = Distributors.list_distributors(params)

    {:ok,
     socket
     |> assign(:distributors, distributors)
     |> assign(:search, "")
     |> assign(:page, 1)
     |> assign(:page_title, "Manage Distributors")
     |> assign(:selected_id, nil)
     |> assign(:approve_modal, false)
     |> assign(:show_dropdown, false)} # ✅ Fix: initialize show_dropdown
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    distributors = Distributors.list_distributors(%{"query" => query, "page" => 1})

    {:noreply,
     socket
     |> assign(:search, query)
     |> assign(:page, 1)
     |> assign(:distributors, distributors)}
  end

  @impl true
  def handle_event("paginate", %{"page" => page}, socket) do
    page = String.to_integer(page)
    distributors = Distributors.list_distributors(%{
      "query" => socket.assigns.search,
      "page" => page
    })

    {:noreply, assign(socket, distributors: distributors, page: page)}
  end

  @impl true
  def handle_event("approve", %{"id" => id}, socket) do
    Distributors.approve_distributor(id)
    distributors = Distributors.list_distributors(%{
      "query" => socket.assigns.search,
      "page" => socket.assigns.page
    })

    {:noreply,
     socket
     |> put_flash(:info, "Distributor approved successfully.")
     |> assign(:distributors, distributors)
     |> assign(:approve_modal, false)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Distributors.delete_distributor(id)
    distributors = Distributors.list_distributors(%{
      "query" => socket.assigns.search,
      "page" => socket.assigns.page
    })

    {:noreply,
     socket
     |> put_flash(:info, "Distributor deleted successfully.")
     |> assign(:distributors, distributors)}
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
