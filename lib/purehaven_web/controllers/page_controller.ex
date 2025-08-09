defmodule PurehavenWeb.PageController do
  use PurehavenWeb, :controller

  alias Purehaven.Repo
  alias Purehaven.Subscriber
  alias Purehaven.Review
  alias Purehaven.ContactMessage
  alias Purehaven.Distributor
  alias Purehaven.Distributors  # <-- Fixed this alias properly

  import Ecto.Query

  # Render functions
  def home(conn, _params), do: render(conn, :home, layout: false)
  def products(conn, _params), do: render(conn, :products, layout: false)
  def aboutus(conn, _params), do: render(conn, :aboutus, layout: false)
  def faqs(conn, _params), do: render(conn, :faqs, layout: false)

  # Contact page
def contactus(conn, _params) do
  contact_changeset = ContactMessage.changeset(%ContactMessage{}, %{})
  distributor_changeset = Distributor.changeset(%Distributor{}, %{})
  render(conn, :contactus, contact_changeset: contact_changeset, distributor_changeset: distributor_changeset)
end

# Submit distributor form
def submit_distributor(conn, %{"distributor" => distributor_params}) do
  %Distributor{}
  |> Distributor.changeset(distributor_params)
  |> Repo.insert()
  |> case do
    {:ok, _dist} ->
      conn
      |> put_flash(:info, "Distributor form submitted successfully! Please check your email for further details.")
      |> redirect(to: ~p"/contactus")

    {:error, distributor_changeset} ->
      contact_changeset = ContactMessage.changeset(%ContactMessage{}, %{})
      render(conn, :contactus, contact_changeset: contact_changeset, distributor_changeset: distributor_changeset)
  end
end

  # Handle Contact message submission
  def send_message(conn, %{"contact_message" => params}) do
    %ContactMessage{}
    |> ContactMessage.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "Message sent successfully!")
        |> redirect(to: ~p"/contactus")

        {:error, contact_changeset} ->
          distributor_changeset = Distributor.changeset(%Distributor{}, %{})
          conn
          |> put_flash(:error, "Failed to send message.")
          |> render(:contactus,
              contact_changeset: contact_changeset,
              distributor_changeset: distributor_changeset,
              layout: false
            )
    end
  end

  # Reviews functionality
  def reviews(conn, _params) do
    changeset = Review.changeset(%Review{}, %{})
    reviews = Repo.all(from r in Review, order_by: [desc: r.inserted_at], limit: 9)
    render(conn, :reviews, reviews: reviews, changeset: changeset)
  end

  def submit_review(conn, %{"review" => review_params}) do
    %Review{}
    |> Review.changeset(review_params)
    |> Repo.insert()
    |> case do
      {:ok, _review} ->
        conn
        |> put_flash(:info, "Review submitted!")
        |> redirect(to: ~p"/reviews")

      {:error, changeset} ->
        reviews = Repo.all(from r in Review, order_by: [desc: r.inserted_at], limit: 9)

        conn
        |> put_flash(:error, "Failed to submit review.")
        |> render(:reviews, changeset: changeset, reviews: reviews)
    end
  end

  # Subscription functionality
  def subscribe(conn, %{"email" => email} = params) do
    case validate_email(email) do
      :ok ->
        %Subscriber{}
        |> Subscriber.changeset(params)
        |> Repo.insert()
        |> case do
          {:ok, _subscriber} ->
            conn
            |> put_flash(:info, "Success! You have successfully subscribed.")
            |> redirect(to: "/home")

          {:error, %Ecto.Changeset{} = _changeset} ->
            conn
            |> put_flash(:error, "Failed to subscribe: Email already subscribed.")
            |> redirect(to: "/home")
        end

      :invalid ->
        conn
        |> put_flash(:error, "Invalid email format.")
        |> redirect(to: "/home")
    end
  end

  # Helper function
  defp validate_email(email) do
    if Regex.match?(~r/^[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/, email) do
      :ok
    else
      :invalid
    end
  end

  # New pages
  def new_products(conn, _params) do
    render(conn, :new_products)
  end

  def private_label(conn, _params) do
    render(conn, :private_label)
  end


end
