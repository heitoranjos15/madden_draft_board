defmodule MaddenDraft.View.Components.Form.AddBoard do
  @behaviour Ratatouille.App

  require Logger

  alias MaddenDraft.View.Components.Form
  alias MaddenDraft.View.Commands.BoardCommand

  @title "Add Board"

  @form_fields [
    :madden,
    :year,
    :team,
    :team_needs,
    :picks
  ]

  def render(model) do
    Form.create_form(model, @title, @form_fields, 6)
  end

  def save(model) do
    BoardCommand.save(model)
    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
