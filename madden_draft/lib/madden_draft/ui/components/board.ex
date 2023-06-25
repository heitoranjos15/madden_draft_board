defmodule MaddenDraft.View.Board do
  @behaviour Ratatouille.App

  require Logger
  alias MaddenDraft.View.Commands.BoardCommand
  alias MaddenDraft.View.Board.Horizontal
  alias MaddenDraft.View.Components.Form.AddPlayer

  def render(model) do
    case model.current_tab do
      :horizontal ->
        Horizontal.render(model, get_board_content(model.draft_selected))

      :add_player ->
        AddPlayer.render(model)

      _ ->
        Horizontal.render(model, get_board_content(model.draft_selected))
    end
  end

  defp get_board_content(draft) do
    BoardCommand.get_board_players(draft)
  end
end
