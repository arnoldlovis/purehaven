defmodule PurehavenWeb.AdminInputLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Production
  alias Purehaven.Production.InputRecord

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:page_title, "Add Input Record")
      |> assign(:changeset, Production.change_input(%InputRecord{}))
      |> assign(:show_dropdown, false)}
  end

  def handle_event("save", %{"input_record" => params}, socket) do
    case Production.create_input(params) do
      {:ok, _input} ->
        {:noreply,
          socket
          |> put_flash(:info, "Record saved successfully!")
          |> push_navigate(to: "/admin/inputs")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
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
