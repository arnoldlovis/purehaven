defmodule Purehaven.Stats do
  import Ecto.Query, warn: false
  alias Purehaven.Repo
  alias Purehaven.Products.Product
  alias Purehaven.Stats.ProductStat
  alias Purehaven.Communications.Distributor

  def total_sales do
    Repo.one(from p in Product, select: sum(p.sales)) || 0
  end

  def total_stock do
    Repo.one(from p in Product, select: sum(p.stock)) || 0
  end

  def total_production do
    Repo.one(from s in ProductStat, select: sum(s.produced)) || 0
  end

  def total_distribution do
    Repo.one(from s in ProductStat, select: sum(s.distributed)) || 0
  end

  def new_distributors_today do
    today = Date.utc_today()

    Repo.aggregate(
      from(d in Distributor, where: fragment("DATE(?)", d.inserted_at) == ^today),
      :count
    ) || 0
  end

  def sales_chart_data do
    today = Date.utc_today()

    last_7_days =
      for i <- 6..0 do
        day = Date.add(today, -i)

        %{
          label: Date.to_string(day),
          sales: Repo.one(
            from p in Product,
            where: fragment("DATE(?)", p.inserted_at) == ^day,
            select: coalesce(sum(p.sales), 0)
          )
        }
      end

    labels = Enum.map(last_7_days, & &1.label)
    data = Enum.map(last_7_days, & &1.sales)

    %{labels: labels, data: data}
  end
end
