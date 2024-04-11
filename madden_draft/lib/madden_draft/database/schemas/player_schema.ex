defmodule MaddenDraft.Database.Schema.Player do
  use Ecto.Schema

  schema "player" do
    field(:name, :string)
    field(:college, :string)
    field(:age, :integer)
    field(:round_expected, :integer)
    field(:height, :string)
    field(:weight, :string)
    field(:skills, :map)
  end
end
