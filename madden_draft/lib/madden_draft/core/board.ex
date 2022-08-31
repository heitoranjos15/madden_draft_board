defmodule MaddenDraft.Core.Board do
  alias MaddenDraft.Core.PlayerBoard

  @type t :: %__MODULE__{
          player_board: [PlayerBoard.t()]
        }

  @enforce_keys [:player_board]
  defstruct player_board: [%{}]

  def new(player_board) do
    struct!(__MODULE__, player_board)
  end
end
