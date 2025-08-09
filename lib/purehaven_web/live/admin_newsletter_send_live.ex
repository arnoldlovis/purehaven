defmodule PurehavenWeb.AdminNewsletterSendLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Communications
  alias Purehaven.Communications.MassEmail
  alias Purehaven.Mailer
  alias Swoosh.Email

  def mount(_params, _session, socket) do
    changeset = MassEmail.changeset(%MassEmail{}, %{})

    {:ok,
      socket
      |> assign(:page_title, "Send Mass Email")
      |> assign(:changeset, changeset)
      |> assign(:loading, false)
    }
  end

  def handle_event("send_email", %{"mass_email" => params}, socket) do
    changeset = MassEmail.changeset(%MassEmail{}, params)

    if changeset.valid? do
      recipients = Communications.list_subscriber_emails()

      Enum.each(recipients, fn email ->
        email_struct =
          Email.new()
          |> Email.to(email)
          |> Email.from({"Purehaven", "noreply@purehaven.com"})
          |> Email.subject(params["subject"])
          |> Email.text_body(params["body"])

        Mailer.deliver(email_struct)
      end)

      {:noreply,
        socket
        |> put_flash(:info, "Mass email sent successfully to #{length(recipients)} subscribers!")
        |> push_navigate(to: ~p"/admin/newsletter/send")
      }
    else
      {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
