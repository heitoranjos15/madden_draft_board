defmodule MaddenDraft.View.Components.Board.PlayerDetails do
  @behaviour MaddenDraft.View

  import MaddenDraft.View.Command.Form
  alias MaddenDraft.View.Integration.BoardIntegration
  alias MaddenDraft.View.Integration.PlayerIntegration

  @title "Player Details"

  @form_fields %{
    :quarterback => [
      :throw_power,
      :short_accuracy,
      :medium_accuracy,
      :deep_accuracy
    ],
    :receiver => [
      :short_route,
      :route_running,
      :catching
    ]
  }

  def spec() do
    %{
      :fields => &fields/1
    }
  end

  def fields(model) do
    player = get_player_in_model(model)
    if is_nil(player) do
      []
    else
      @form_fields[player]
    end
  end

  def render(model) do
    generate(model, @title, @form_fields.quarterback, 3)
  end

  def get_player_in_model(model) do
    %{draft_selected: draft, cursor: %{label_focus: player_rank}} = model

    BoardIntegration.get_board_player(draft, player_rank)
  end
end
