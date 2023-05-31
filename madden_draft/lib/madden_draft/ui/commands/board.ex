defmodule MaddenDraft.View.Commands.BoardCommand do
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
end
