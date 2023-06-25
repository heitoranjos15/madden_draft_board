defmodule MaddenDraft.View.Components.Form.AddPlayer do
  @behaviour Ratatouille.App

  require Logger

  alias MaddenDraft.View.Components.Form

  @title "Add Player"

  @form_player_fields [
    :name,
    :position,
    :age,
    :college,
    :expected
  ]

  @form_skills_fields %{
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

  def render(model) do
    Form.create_form(model, @title, @form_player_fields, 3)
  end
end
