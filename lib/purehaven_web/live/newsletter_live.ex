defmodule PurehavenWeb.NewsletterLive do
  use PurehavenWeb, :live_view
  import Phoenix.Component

  def mount(_params, _session, socket) do
    socket = put_flash(socket, :info, "Test flash message")
    {:ok, assign(socket, email: "")}
  end

  def handle_event("subscribe", %{"email" => email}, socket) do
    case Purehaven.Newsletter.subscribe(email) do
      {:ok, _subscription} ->
        {:noreply,
         socket
         |> assign(:email, "")
         |> put_flash(:info, "Successfully subscribed!")}

      {:error, :invalid_email} ->
        {:noreply, put_flash(socket, :error, "Please enter a valid email address.")}

      {:error, :already_subscribed} ->
        {:noreply, put_flash(socket, :error, "You are already subscribed.")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Something went wrong: #{inspect(reason)}")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="mb-12 pb-8 border-b border-gray-300 w-full mx-auto">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between">
        <div class="md:w-1/2 text-left md:ml-4">
          <h3 class="text-2xl font-bold text-gray-900">Want product news and updates?</h3>
          
          <p class="text-gray-600 mt-2">Sign up for our newsletter.</p>
        </div>
        
        <div class="md:w-1/2 flex justify-end md:mr-4">
          <div class="w-full max-w-md">
            <.form
              for={:newsletter}
              as={:email}
              id="newsletter-form"
              phx-submit="subscribe"
              class="flex space-x-3"
            >
              <input
                type="email"
                name="email"
                value={@email}
                placeholder="Enter your email"
                required
                class="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                type="submit"
                class="px-6 py-2 bg-indigo-600 text-white font-medium rounded-md hover:bg-indigo-700 transition"
              >
                Subscribe
              </button>
            </.form>
            
            <p class="text-gray-500 text-sm mt-2">
              We care about your data. Read our <a href="#" class="text-indigo-600 hover:underline">privacy policy</a>.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
