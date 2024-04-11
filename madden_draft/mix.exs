defmodule MaddenDraft.MixProject do
  use Mix.Project

  def project do
    [
      app: :madden_draft,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MaddenDraft.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ratatouille, "~> 0.5.0"},
      {:ecto, "~> 3.10"},
      {:jason, "~> 1.0"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.17"},
      {:dotenvy, "~> 0.8.0"}
    ]
  end
end
