defmodule PurehavenWeb.ProductController do
  use PurehavenWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def new_products(conn, _params) do
    render(conn, :new_products)
  end

  def private_label(conn, _params) do
    render(conn, :private_label)
  end
end
