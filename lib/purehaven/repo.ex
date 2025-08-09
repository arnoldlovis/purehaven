defmodule Purehaven.Repo do
  use Ecto.Repo,
    otp_app: :purehaven,
    adapter: Ecto.Adapters.Postgres

    use Scrivener, page_size: 10
end
