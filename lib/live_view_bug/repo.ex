defmodule LiveViewBug.Repo do
  use Ecto.Repo,
    otp_app: :live_view_bug,
    adapter: Ecto.Adapters.Postgres
end
