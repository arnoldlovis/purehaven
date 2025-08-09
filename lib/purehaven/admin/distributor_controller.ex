defmodule PurehavenWeb.Admin.DistributorController do
  use PurehavenWeb, :controller

  alias Purehaven.Distributors

  def export(conn, _params) do
    csv_content =
      Distributors.export_distributors_csv()
      |> encode_csv()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"distributors_export.csv\"")
    |> send_resp(200, csv_content)
  end

  defp encode_csv(rows) do
    rows
    |> CSV.encode()
    |> Enum.join()
  end
end
