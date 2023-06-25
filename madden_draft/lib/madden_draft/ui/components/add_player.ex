defmodule MaddenDraft.View.Components.AddPlayer do
  @behaviour Ratatouille.App

  require Logger

  alias MaddenDraft.View.Command.Form

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
    Form.generate(model, @title, @form_player_fields, 3)
  end

  def fields(), do: @form_player_fields

  def get_skill_fields, do: @form_skills_fields
end
