defmodule PurehavenWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use PurehavenWeb, :html

  import Phoenix.HTML
  import Phoenix.HTML.Form
  embed_templates "page_html/*"
end
