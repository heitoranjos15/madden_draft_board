defmodule MaddenDraft.View.Components.AddBoard do
  @behaviour Ratatouille.App

  require Logger

  alias MaddenDraft.View.Command.Form
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
    Form.generate(model, @title, @form_fields, 6)
  end

  def save(model) do
    BoardIntegration.save(model)
    Kernel.put_in(model, [:form_data, :status], "saved")
  end

  def fields(), do: @form_fields
end
