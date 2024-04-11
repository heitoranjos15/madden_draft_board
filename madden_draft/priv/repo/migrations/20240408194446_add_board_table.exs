defmodule MaddenDraft.Database.Repo.Migrations.AddBoardTable do
  use Ecto.Migration

  def up do
    create table("board") do
      add :name, :string, null: false
      add :players, {:array, :map}, null: false
      add :status, :string
      add :year, :string
      add :madden_version, :string
    end
  end

  def down do
    drop table("board")   
  end

end
