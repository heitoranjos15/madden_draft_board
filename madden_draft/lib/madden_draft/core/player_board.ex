defmodule MaddenDraft.Core.PlayerBoard do
  alias MaddenDraft.Core.Player

  @type t :: %__MODULE__{
          player: Player.t(),
          rank: Integer.t()
        }

  @enforce_keys [:player, :rank]
  defstruct player: %{},
            rank: 0

  def new(player, rank) do
    struct!(__MODULE__, %{:player => player, :rank => rank})
  end
end
