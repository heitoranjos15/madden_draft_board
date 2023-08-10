defmodule MaddenDraft.View.Integration.BoardIntegration do
  require Logger

  alias MaddenDraft.Boundary.DraftSupervisor
  alias MaddenDraft.Boundary.BoardManager

  def save(model) do
    board_name = Kernel.get_in(model, [:form_data, :add_board, :madden])
    DraftSupervisor.create_board(board_name)
  end

  def list_boards() do
    DraftSupervisor.get_drafts()
  end

  def get_board_players(draft_name) do
    BoardManager.show(draft_name)
  end

  def update_player_rank(new_rank, player_rank, draft_name) do
    BoardManager.update_player_rank(draft_name, player_rank, new_rank)
  end
end
