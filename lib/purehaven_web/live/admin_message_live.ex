defmodule PurehavenWeb.AdminMessageLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Communications

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> load_messages()
     |> assign(:show_dropdown, false)}
  end

  defp assign_defaults(socket) do
    assign(socket,
      search: "",
      from: nil,
      to: nil,
      page: 1,
      total_pages: 1,
      messages: []
    )
  end

  defp load_messages(socket) do
    {messages, total_pages} =
      Communications.list_contact_messages_paginated(
        socket.assigns.search,
        socket.assigns.from,
        socket.assigns.to,
        socket.assigns.page
      )

    assign(socket, messages: messages, total_pages: total_pages)
  end

  @impl true
  def handle_event("filter", %{"search" => search, "from" => from_str, "to" => to_str}, socket) do
    from = parse_start_datetime(from_str)
    to = parse_end_datetime(to_str)

    {messages, total_pages} = Communications.list_contact_messages_paginated(search, from, to, 1)

    {:noreply,
     socket
     |> assign(:search, search)
     |> assign(:from, from)
     |> assign(:to, to)
     |> assign(:page, 1)
     |> assign(:messages, messages)
     |> assign(:total_pages, total_pages)}
  end

  def handle_event("reset_filters", _params, socket) do
    {:noreply,
     socket
     |> assign_defaults()
     |> load_messages()}
  end

  def handle_event("prev_page", _params, socket) do
    new_page = max(socket.assigns.page - 1, 1)
    {:noreply, update_page(socket, new_page)}
  end

  def handle_event("next_page", _params, socket) do
    new_page = min(socket.assigns.page + 1, socket.assigns.total_pages)
    {:noreply, update_page(socket, new_page)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    message = Communications.get_contact_message!(id)
    {:ok, _} = Communications.delete_contact_message(message)
    {:noreply, load_messages(socket)}
  end

  defp update_page(socket, new_page) do
    {messages, total_pages} =
      Communications.list_contact_messages_paginated(
        socket.assigns.search,
        socket.assigns.from,
        socket.assigns.to,
        new_page
      )

    assign(socket, page: new_page, messages: messages, total_pages: total_pages)
  end

  defp parse_start_datetime(""), do: nil
  defp parse_start_datetime(nil), do: nil
  defp parse_start_datetime(str) do
    case Date.from_iso8601(str) do
      {:ok, date} -> NaiveDateTime.new!(date, ~T[00:00:00])
      _ -> nil
    end
  end

  defp parse_end_datetime(""), do: nil
  defp parse_end_datetime(nil), do: nil
  defp parse_end_datetime(str) do
    case Date.from_iso8601(str) do
      {:ok, date} -> NaiveDateTime.new!(date, ~T[23:59:59])
      _ -> nil
    end
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
