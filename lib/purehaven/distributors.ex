defmodule Purehaven.Distributors do
  import Ecto.Query, warn: false
  alias Purehaven.Repo
  alias Purehaven.Distributor

  @doc "Paginate and list all distributors"
  def list_distributors(params \\ %{}) do
    query =
      Distributor
      |> maybe_filter_query(params["query"])

    query
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
  end

  defp maybe_filter_query(query, nil), do: query
  defp maybe_filter_query(query, ""), do: query

  defp maybe_filter_query(query, search) do
    pattern = "%#{search}%"

    from d in query,
      where:
        ilike(d.first_name, ^pattern) or
        ilike(d.last_name, ^pattern) or
        ilike(d.company, ^pattern) or
        ilike(d.email, ^pattern)
  end

  @doc "Search distributors by name/company/email"
  def search_distributors(query) when is_binary(query) and query != "" do
    Distributor
    |> where([d],
      ilike(d.first_name, ^"%#{query}%") or
      ilike(d.last_name, ^"%#{query}%") or
      ilike(d.company, ^"%#{query}%") or
      ilike(d.email, ^"%#{query}%")
    )
    |> Repo.all()
  end

  def search_distributors(_), do: list_distributors() # fallback

  @doc "Approve a distributor"
  def approve_distributor(id) do
    distributor = Repo.get!(Distributor, id)

    distributor
    |> Ecto.Changeset.change(%{status: "Approved"})
    |> Repo.update()
  end

  @doc "Delete a distributor"
  def delete_distributor(id) do
    distributor = Repo.get!(Distributor, id)
    Repo.delete(distributor)
  end

  @doc "Export all distributors to CSV"
  def export_distributors_csv do
    distributors = Repo.all(Distributor)

    [
      ["First Name", "Last Name", "Company", "Email", "Phone", "Location", "Status"]
    ] ++
    Enum.map(distributors, fn d ->
      [
        d.first_name,
        d.last_name,
        d.company,
        d.email,
        d.phone,
        d.location,
        d.status
      ]
    end)
  end
end
