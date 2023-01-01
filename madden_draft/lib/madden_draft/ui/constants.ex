defmodule MaddenDraft.View.Constants do
  @form_fields %{
    :add_board => [:madden, :year, :team, :team_needs, :picks]
  }

  def current_tab_field_limit(%{current_tab: current_tab}),
    do: @form_fields |> Map.get(current_tab) |> length |> Kernel.-(1)

  def current_tab_fields(%{current_tab: current_tab}),
    do: current_tab_fields(current_tab)

  def current_tab_fields(current_tab),
    do: @form_fields |> Map.get(current_tab)
end
