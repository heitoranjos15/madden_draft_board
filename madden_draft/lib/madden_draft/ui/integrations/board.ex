defmodule MaddenDraft.View.Integration.BoardIntegration do
  require Logger

  alias MaddenDraft.Boundary.DraftSupervisor
  alias MaddenDraft.Boundary.BoardManager

  def save(model) do
    board_name = Kernel.get_in(model, [:form_data, :add_board, :madden])
    DraftSupervisor.create_board(board_name)
    BoardManager.lazy_players(board_name)
  end

  def list_boards() do
    DraftSupervisor.get_drafts()
  end

  def get_board_players(draft_name) do
    BoardManager.show(draft_name)
  end

  def get_board_player(draft, player_rank) do
    BoardManager.show_players_filter(draft, :rank, player_rank)
  end

  def update_player_rank(choose, player_rank, draft_name) do
    BoardManager.update_player_rank(draft_name, player_rank, choose)
  end
end
