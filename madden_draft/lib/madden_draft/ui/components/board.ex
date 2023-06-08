defmodule MaddenDraft.View.Board do
  @behaviour Ratatouille.App

  require Logger
  import Ratatouille.View
  alias MaddenDraft.View.Commands.BoardCommand
  alias MaddenDraft.View.Helpers.Styles
  alias MaddenDraft.View.Board.Horizontal

  def render(model) do
    case model.current_tab do
      :horizontal ->
        Horizontal.render(model, get_board_content(model.draft_selected))

      _ ->
        Horizontal.render(model, get_board_content(model.draft_selected))
    end
  end

  defp get_board_content(draft) do
    BoardCommand.get_board_players(draft)
  end
end
