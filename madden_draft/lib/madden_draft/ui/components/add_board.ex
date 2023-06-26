defmodule MaddenDraft.View.Components.AddBoard do
  @behaviour MaddenDraft.View

  require Logger

  import MaddenDraft.View.Command.Form
  alias MaddenDraft.View.Integration.BoardIntegration

  @title "Add Board"

  @form_fields [
    :madden,
    :year,
    :team,
    :team_needs,
    :picks
  ]

  def render(model) do
    generate(model, @title, @form_fields, 6)
  end

  def name, do: :add_board

  def fields, do: @form_fields

  def bindings,
    do: %{?a => {:text_mode, :start}, ?c => {:text_mode, :clean}, ?w => :save, ?q => :quit}

  def save(model) do
    BoardIntegration.save(model)
    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
