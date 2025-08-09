defmodule PurehavenWeb.AdminReviewLive do
  use PurehavenWeb, :live_view
  alias Purehaven.Communications

  @per_page 10

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page, 1)
      |> assign(:show_dropdown, false)
      |> assign(:sort_order, :desc)
      |> load_reviews()

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Communications.get_review!(id)
    {:ok, _} = Communications.delete_review(review)
    {:noreply, refresh_reviews(socket)}
  end

  def handle_event("prev_page", _params, %{assigns: %{page: page}} = socket) when page > 1 do
    {:noreply, assign(socket, :page, page - 1) |> load_reviews()}
  end

  def handle_event("next_page", _params, %{assigns: %{page: page, total_pages: total}} = socket)
      when page < total do
    {:noreply, assign(socket, :page, page + 1) |> load_reviews()}
  end

  def handle_event("toggle_sort", _params, socket) do
    new_sort = if socket.assigns.sort_order == :desc, do: :asc, else: :desc

    {:noreply,
     socket
     |> assign(:sort_order, new_sort)
     |> assign(:page, 1) # Reset to page 1 on sort change
     |> load_reviews()}
  end

  #
  # ─── PRIVATE HELPERS ────────────────────────────────────────────────
  #

  defp load_reviews(socket) do
    all_reviews = Communications.list_reviews_sorted(socket.assigns.sort_order)
    page = socket.assigns.page

    paginated =
      all_reviews
      |> Enum.chunk_every(@per_page)
      |> Enum.at(page - 1, [])

    total_pages = div(length(all_reviews) + @per_page - 1, @per_page)

    socket
    |> assign(:reviews, paginated)
    |> assign(:total_pages, total_pages)
  end

  defp refresh_reviews(socket) do
    load_reviews(socket)
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
