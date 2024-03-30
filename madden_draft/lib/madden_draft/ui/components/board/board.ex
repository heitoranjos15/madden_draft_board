defmodule MaddenDraft.View.Components.Board do
  @behaviour MaddenDraft.View

  import Ratatouille.Constants, only: [key: 1]

  require Logger
  import Ratatouille.View
  alias MaddenDraft.View.Components.Board.PlayerDetails
  alias MaddenDraft.View.Helpers.Styles
  alias MaddenDraft.View.Integration.BoardIntegration
  alias MaddenDraft.View.Components.AddPlayer

  @players_columns [
    "rank",
    "name",
    # "age",
    "position",
    "college",
    "status"
  ]

  def render(model) do
    case model.current_tab.get_spec(:name) do
      :horizontal -> horizontal_render(model)
      _ -> model.current_tab.render(model)
    end
  end

  defp horizontal_render(model) do
    %{draft_selected: draft} = model
    board_data = BoardIntegration.get_board_players(draft)

    row do
      column(size: 12) do
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

          PlayerDetails.render(model)
      end
    end
  end

  def get_spec(spec_name), do: Map.get(spec(), spec_name)

  def spec() do
    %{
      :name => :horizontal,
      :tabs => [
        {:home, "[B]ack"},
        {:horizontal, "[H]orizontal"},
        {:vertical, "[V]ertical"},
        {:add_player, "[A]dd player"},
        {:edit_player, "[E]dit player"}
      ],
      :bindings => &bindings/0,
      :fields => &fields/1
    }
  end

  defp bindings(),
    do: %{
      ?b =>
        {:page,
         [
           MaddenDraft.View.Components.Home,
           MaddenDraft.View.Components.Home
         ]},
      ?h => {:tab, MaddenDraft.View.Components.Board},
      ?a => {:tab, AddPlayer},
      key(:enter) => {:select},
      :selection => %{
        ?j => %{:action => &down_rank/1, :cursor_update => :next},
        ?k => %{:action => &up_rank/1, :cursor_update => :previous},
        ?e => :edit
      }
    }

  defp fields(model) do
    if model.draft_selected == "" do
      [0]
    else
      model.draft_selected
      |> BoardIntegration.get_board_players()
      |> Enum.map(fn player -> player.rank end)
      |> Enum.sort(&(&1 < &2))
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

  defp down_rank(model), do: move_player_rank(model, :down)

  defp up_rank(model), do: move_player_rank(model, :up)

  defp move_player_rank(model, new_rank) do
    %{draft_selected: draft, cursor: %{label_focus: player_rank}} = model

    choose =
      case new_rank do
        :down -> Kernel.+(player_rank, 1)
        :up -> Kernel.-(player_rank, 1)
      end

    BoardIntegration.update_player_rank(choose, player_rank, draft)
    model
  end
end
