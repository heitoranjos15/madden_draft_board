defmodule MaddenDraft.View.Components.AddPlayer do
  @behaviour MaddenDraft.View

  import MaddenDraft.View.Command.Form
  alias MaddenDraft.View.Integration.PlayerIntegration

  @title "Add Player"

  @form_player_fields [
    :name,
    :position,
    :age,
    :college,
    :round_expected
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
    generate(model, @title, @form_player_fields, 3)
  end

  def name, do: :add_player

  def fields, do: @form_player_fields

  def bindings,
    do: %{?a => {:text_mode, :start}, ?c => {:text_mode, :clean}, ?w => :save, ?q => :quit}

  def get_skill_fields, do: @form_skills_fields

  def save(model) do
    PlayerIntegration.save(model)
    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
