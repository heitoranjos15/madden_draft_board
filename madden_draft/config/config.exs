import Config

config :madden_draft, ecto_repos: [MaddenDraft.Database.Repo]

config :madden_draft, MaddenDraft.Database.Repo,
  database: System.fetch_env!("DATABASE"),
  username: System.fetch_env!("PGUSER"),
  password: System.fetch_env!("PGPASSWORD"),
  hostname: System.fetch_env!("PGHOST")
  # OR use a URL to connect instead
  # url: "postgres://postgres:postgres@localhost/ecto_simple"
