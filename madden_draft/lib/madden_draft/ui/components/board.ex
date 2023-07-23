defmodule MaddenDraft.View.Components.Board do
  @behaviour MaddenDraft.View

  require Logger
  import Ratatouille.View
  alias MaddenDraft.View.Helpers.Styles
  alias MaddenDraft.View.Integration.BoardIntegration
  alias MaddenDraft.View.Components.AddPlayer

  @players_columns [
    "rank",
    "name",
    "age",
    "position",
    "college",
    "status"
  ]

  def render(model) do
    case model.current_tab.name do
      :horizontal -> horizontal_render(model)
      _ -> model.current_tab.render(model)
    end
  end

  defp horizontal_render(model) do
    %{draft_selected: draft} = model
    board_data = get_board_players(draft)

    panel(Styles.default_style(:panel, draft)) do
      table do
        table_row do
          for column <- @players_columns do
            table_cell(content: column)
          end
        end

        if is_list(board_data) do
          players_row(model, board_data)
        else
          label(content: "Board empty !")
        end
      end
    end
  end

  def tabs(),
    do: [
      {:home, "[B]ack"},
      {:horizontal, "[H]orizontal"},
      {:vertical, "[V]ertical"},
      {:add_player, "[A]dd player"},
      {:edit_player, "[E]dit player"}
    ]

  def bindings(),
    do: %{
      ?b =>
        {:page,
         [
           MaddenDraft.View.Components.Home,
           MaddenDraft.View.Components.Home
         ]},
      ?h => {:tab, MaddenDraft.View.Components.Board},
      ?a => {:tab, AddPlayer}
    }

  def name, do: :horizontal

  def fields(model) do
    if model.draft_selected == "" do
      [0]
    else
      model.draft_selected
      |> BoardIntegration.get_board_players()
      |> Enum.map(fn player -> player.rank end)
    end
  end

  defp players_row(model, board_data) do
    for data <- board_data do
      player = data.player

      table_row do
        for column <- @players_columns do
          content =
            case column do
              "rank" -> Integer.to_string(data.rank)
              "status" -> Atom.to_string(data.status)
              "age" -> player.age
              _ -> Map.get(player, String.to_atom(column))
            end

          table_cell(Styles.get_style(:label, model.cursor.label_focus === data.rank, content))
        end
      end
    end
  end

  defp get_board_players(draft) do
    BoardIntegration.get_board_players(draft)
  end
end
