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

  def get_spec(spec_name), do: Map.get(spec(), spec_name)

  def spec do
    %{
      :name => :add_player,
      :bindings => &bindings/0,
      :fields => &fields/1,
      :save => &save/1
    }
  end

  defp fields(_), do: @form_player_fields

  defp bindings,
    do: %{?a => {:text_mode, :start}, ?c => {:text_mode, :clean}, ?w => :save, ?q => :quit}

  defp get_skill_fields, do: @form_skills_fields

  defp save(model) do
    PlayerIntegration.save(model)
    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
