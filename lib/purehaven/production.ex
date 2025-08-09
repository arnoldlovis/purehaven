defmodule Purehaven.Production do
  import Ecto.Query, warn: false
  alias Purehaven.Repo
  alias Purehaven.Production.InputRecord

  def change_input(%InputRecord{} = input_record, attrs \\ %{}) do
    InputRecord.changeset(input_record, attrs)
  end

  def create_input(attrs) do
    %InputRecord{}
    |> InputRecord.changeset(attrs)
    |> Repo.insert()
  end

  def list_inputs do
    Repo.all(InputRecord)
  end

    # Fetch stats totals
  def fetch_dashboard_stats do
    %{
      total_production: Repo.one(from ir in InputRecord, select: sum(ir.produced)) || 0,
      total_sales: Repo.one(from ir in InputRecord, select: sum(ir.sold)) || 0,
      total_distribution: Repo.one(from ir in InputRecord, select: sum(ir.distributed)) || 0,
      total_stock: Repo.one(from ir in InputRecord, select: sum(ir.stock_remaining)) || 0
    }
  end

  # Fetch chart data (sales over last 7 days)
  def fetch_chart_data do
    today = Date.utc_today()

    days =
      6..0
      |> Enum.map(fn offset -> Date.add(today, -offset) end)

    labels = Enum.map(days, &Date.to_iso8601/1)

    data =
      Enum.map(days, fn date ->
        Repo.one(
          from ir in InputRecord,
            where: fragment("DATE(?)", ir.inserted_at) == ^date,
            select: coalesce(sum(ir.sold), 0)
        ) || 0
      end)

    %{
      labels: labels,
      data: data
    }
    end
   end
