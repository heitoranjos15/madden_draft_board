defmodule MaddenDraft.Database.Schema.Board do
  use Ecto.Schema

  schema "board" do
    field(:name, :string)
    field(:players, {:array, :map})
    field(:year, :string)
    field(:madden_version, :string)
    field(:status, :string)
  end
end
