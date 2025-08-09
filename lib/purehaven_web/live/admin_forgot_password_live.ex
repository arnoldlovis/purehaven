defmodule PurehavenWeb.AdminForgotPasswordLive do
  use PurehavenWeb, :live_view

  alias Purehaven.Accounts

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-gray-100 px-4">
      <div class="w-full max-w-md bg-white rounded-lg shadow-md p-8 space-y-6">
        <div class="text-center">
          <h2 class="text-2xl font-bold text-gray-800">Forgot your password?</h2>
          <p class="mt-2 text-sm text-gray-600">We'll send a password reset link to your inbox</p>
        </div>

        <.simple_form
          for={@form}
          id="reset_password_form"
          phx-submit="send_email"
          class="space-y-4"
        >
          <.input
            field={@form[:email]}
            type="email"
            label="Email Address"
            placeholder="you@example.com"
            required
            class="w-full"
          />

          <:actions>
            <.button
              phx-disable-with="Sending..."
              class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2 px-4 rounded shadow transition"
            >
              Send password reset instructions
            </.button>
          </:actions>
        </.simple_form>

        <div class="text-center text-sm text-gray-600 mt-4 space-x-2">
          <.link href={~p"/admins/log_in"} class="font-medium text-indigo-600 hover:underline">
            Back to Login
          </.link>
          <span>|</span>
          <.link href={~p"/admins/register"} class="font-medium text-indigo-600 hover:underline">
            Register
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "admin"))}
  end

  def handle_event("send_email", %{"admin" => %{"email" => email}}, socket) do
    if admin = Accounts.get_admin_by_email(email) do
      Accounts.deliver_admin_reset_password_instructions(
        admin,
        &url(~p"/admins/reset_password/#{&1}")
      )
    end

    info = "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
