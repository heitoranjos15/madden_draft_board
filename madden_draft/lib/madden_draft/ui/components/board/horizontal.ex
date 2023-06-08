defmodule MaddenDraft.View.Board.Horizontal do
  require Logger
  import Ratatouille.View
  alias MaddenDraft.View.Helpers.Styles

  @players_columns [
    "rank",
    "name",
    "age",
    "position",
    "college",
    "status"
  ]

  def render(model, board_data) do
    panel(Styles.default_style(:panel, model.draft_selected)) do
      table do
        table_row do
          for column <- @players_columns do
            table_cell(content: column)
          end
        end

        players_row(board_data)
      end
    end
  end

  defp players_row(board_data) do
    for data <- board_data do
      player = data.player

      table_row do
        for column <- @players_columns do
          content =
            case column do
              "rank" -> Integer.to_string(data.rank)
              "status" -> Atom.to_string(data.status)
              "age" -> Integer.to_string(player.age)
              _ -> Map.get(player, String.to_atom(column))
            end

          table_cell(content: content)
        end
      end
    end
  end
end
