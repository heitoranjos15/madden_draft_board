defmodule MaddenDraft.View.Components.Board do
  @behaviour MaddenDraft.View

  require Logger
  alias MaddenDraft.View.Integration.BoardIntegration
  alias MaddenDraft.View.Components.Board.Horizontal
  alias MaddenDraft.View.Components.AddPlayer

  def render(model) do
    case model.current_tab.name do
      :horizontal ->
        Horizontal.render(model, get_board_content(model.draft_selected))

      _ ->
        model.current_tab.render(model)
    end
  end

  def name(), do: :horizontal

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
      ?b => {:page, [Home, Home]},
      ?h => {:tab, MaddenDraft.View.Components.Board},
      ?c => {:tab, AddPlayer}
    }

  def fields(), do: []

  defp get_board_content(draft) do
    BoardIntegration.get_board_players(draft)
  end
end
