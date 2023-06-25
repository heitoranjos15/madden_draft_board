defmodule MaddenDraft.View.Integration.PlayerIntegration do
  require Logger

  alias MaddenDraft.Boundary.BoardManager

  def save(model) do
    %{draft_selected: board} = model

    player = Kernel.get_in(model, [:form_data, :add_player])
    BoardManager.add_player_to_board(board, player)
  end
end
