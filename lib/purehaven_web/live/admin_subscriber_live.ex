defmodule PurehavenWeb.AdminSubscriberLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Communications

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> load_subscribers()
     |> assign(:show_dropdown, false)}
  end

  defp assign_defaults(socket) do
    assign(socket,
      search: "",
      from: nil,
      to: nil,
      page: 1,
      total_pages: 1,
      subscribers: []
    )
  end

  defp load_subscribers(socket) do
    {subs, total_pages} =
      Communications.list_subscribers_paginated(
        socket.assigns.search,
        socket.assigns.from,
        socket.assigns.to,
        socket.assigns.page
      )

    assign(socket, subscribers: subs, total_pages: total_pages)
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    {:noreply,
     socket
     |> assign(search: search, page: 1)
     |> load_subscribers()}
  end

  def handle_event("prev_page", _params, socket) do
    {:noreply,
     socket
     |> update(:page, &max(&1 - 1, 1))
     |> load_subscribers()}
  end

  def handle_event("next_page", _params, socket) do
    {:noreply,
     socket
     |> update(:page, &min(&1 + 1, socket.assigns.total_pages))
     |> load_subscribers()}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    subscriber = Communications.get_subscriber!(id)
    {:ok, _} = Communications.delete_subscriber(subscriber)
    {:noreply, load_subscribers(socket)}
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
