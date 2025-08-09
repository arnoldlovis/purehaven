defmodule Purehaven.Communications do
  @moduledoc """
  The Communications context handles subscribers, reviews, contact messages, and related data.
  """
  import Ecto.Changeset
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias Purehaven.Repo
  alias Purehaven.Subscriber
  alias Purehaven.Review
  alias Purehaven.ContactMessage

  @per_page 10

  # ── SUBSCRIBERS ───────────────────────────────

  def get_subscriber!(id), do: Repo.get!(Subscriber, id)
  def delete_subscriber(%Subscriber{} = subscriber), do: Repo.delete(subscriber)

  def list_subscribers_paginated(search \\ "", from \\ nil, to \\ nil, page \\ 1) do
    base_query =
      Subscriber
      |> filter_email(search)
      |> filter_date_range(from, to)

    total_count = base_query |> select([s], count(s.id)) |> Repo.one()

    subscribers =
      base_query
      |> order_by(desc: :inserted_at)
      |> offset(^((page - 1) * @per_page))
      |> limit(^@per_page)
      |> Repo.all()

    total_pages = div(total_count + @per_page - 1, @per_page)

    {subscribers, total_pages}
  end

  # ── REVIEWS ───────────────────────────────────

  def list_reviews_sorted(order \\ :desc) do
    from(r in Review, order_by: [{^order, r.inserted_at}])
    |> Repo.all()
  end

  def get_review!(id), do: Repo.get!(Review, id)
  def delete_review(%Review{} = review), do: Repo.delete(review)

  # ── CONTACT MESSAGES ──────────────────────────

  def get_contact_message!(id), do: Repo.get!(ContactMessage, id)
  def delete_contact_message(%ContactMessage{} = message), do: Repo.delete(message)

  def list_contact_messages_paginated(search \\ "", from \\ nil, to \\ nil, page \\ 1) do
    base_query =
      ContactMessage
      |> filter_email(search)
      |> filter_date_range(from, to)

    total_count = base_query |> select([m], count(m.id)) |> Repo.one()

    messages =
      base_query
      |> order_by(desc: :inserted_at)
      |> offset(^((page - 1) * @per_page))
      |> limit(^@per_page)
      |> Repo.all()

    total_pages = div(total_count + @per_page - 1, @per_page)

    {messages, total_pages}
  end

  # ── PRIVATE FILTER HELPERS ────────────────────

  # Generic email filter
  defp filter_email(query, ""), do: query
  defp filter_email(query, search) do
    pattern = "%#{search}%"
    where(query, [e], ilike(e.email, ^pattern))
  end

  # Generic date range filter
  defp filter_date_range(query, nil, nil), do: query

  defp filter_date_range(query, from, nil) do
    from(m in query, where: m.inserted_at >= ^from)
  end

  defp filter_date_range(query, nil, to) do
    from(m in query, where: m.inserted_at <= ^to)
  end

  defp filter_date_range(query, from, to) do
    from(m in query, where: m.inserted_at >= ^from and m.inserted_at <= ^to)
  end

  def mass_email_changeset(params \\ %{}) do
    types = %{subject: :string, body: :string}

    {%{}, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:subject, :body])
  end
end
