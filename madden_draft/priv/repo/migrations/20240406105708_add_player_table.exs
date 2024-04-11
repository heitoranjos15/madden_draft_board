defmodule MaddenDraft.Database.Repo.Migrations.AddPlayerTable do
  use Ecto.Migration

  def up do
    create table("player") do
      add :name, :string
      add :college, :string
      add :age, :integer
      add :round_expected, :integer
      add :height, :string
      add :weight, :string
      add :skills, :map
    end
  end

  def down do
    drop table("player")
  end
end
