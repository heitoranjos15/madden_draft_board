defmodule MaddenDraft.Database.Repo do
  use Ecto.Repo,
    otp_app: :madden_draft,
    adapter: Ecto.Adapters.Postgres
end
