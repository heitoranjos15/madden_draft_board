defmodule MaddenDraft.View.Board do
  @behaviour Ratatouille.App

  require Logger
  import Ratatouille.View
  alias MaddenDraft.View.Commands.BoardCommand
  alias MaddenDraft.View.Helpers.Styles

  def render(model) do
    panel(Styles.default_style(:panel, model.draft_selected)) do
      row do
        column(size: 12) do
          build_players_list(get_board_players(model.draft_selected))
        end
      end
    end
  end

  defp build_players_list(players) do
    for player <- players do
      label(Styles.default_style(:label, player.player.name))
    end
  end

  defp get_board_players(draft) do
    BoardCommand.get_board_players(draft)
  end
end
