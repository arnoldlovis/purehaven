defmodule PurehavenWeb.AdminLoginLive do
  use PurehavenWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex">
  <!-- Left image section -->
  <div class="w-1/2 hidden lg:block">
    <img src="/images/stacked-waves.png" alt="Login visual" class="h-full w-full object-cover" />
  </div>

  <!-- Right form section -->
  <div class="w-full lg:w-1/2 flex items-center justify-center bg-gray-100 px-4">
    <div class="w-full max-w-md bg-white rounded-lg shadow-lg p-8 space-y-6">
      <div class="text-center">
        <h2 class="text-2xl font-bold text-gray-800">Log in to your admin account</h2>
        <p class="mt-2 text-sm text-gray-600">
          Don’t have an account?
          <.link navigate={~p"/admins/register"} class="font-semibold text-indigo-600 hover:underline">
            Register now
          </.link>
        </p>
      </div>

      <.simple_form
        for={@form}
        id="login_form"
        action={~p"/admins/log_in"}
        phx-update="ignore"
        class="space-y-4"
      >
        <.input
          field={@form[:email]}
          type="email"
          label="Email Address"
          required
          class="w-full"
        />
        <.input
          field={@form[:password]}
          type="password"
          label="Password"
          required
          class="w-full"
        />

        <:actions>
          <div class="flex items-center justify-between">
            <.input
              field={@form[:remember_me]}
              type="checkbox"
              label="Remember me"
            />
            <.link href={~p"/admins/reset_password"} class="text-sm font-medium text-indigo-600 hover:underline">
              Forgot password?
            </.link>
          </div>
        </:actions>

        <:actions>
          <.button
            phx-disable-with="Logging in..."
            class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2 px-4 rounded shadow transition"
          >
            Log in →
          </.button>
        </:actions>
      </.simple_form>
    </div>
  </div>
</div>

    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "admin")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
