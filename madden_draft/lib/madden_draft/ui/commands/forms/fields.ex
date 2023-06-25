defmodule MaddenDraft.View.Command.Form.Fields do
  alias MaddenDraft.View.Components.{
    AddPlayer,
    AddBoard
  }

  alias MaddenDraft.Boundary.DraftSupervisor

  @tab_fields %{
    :add_board => AddBoard.fields(),
    :add_player => AddPlayer.fields()
  }

  @magnifier "🔍"

  def current_tab_field_limit(%{current_tab: :home}),
    do: DraftSupervisor.get_drafts() |> length |> Kernel.-(1)

  def current_tab_field_limit(%{current_tab: current_tab}),
    do: @tab_fields |> Map.get(current_tab) |> length |> Kernel.-(1)

  def current_tab_fields(%{current_tab: current_tab}),
    do: current_tab_fields(current_tab)

  def current_tab_fields(:home) do
    drafts = DraftSupervisor.get_drafts()
    Enum.map(drafts, fn draft -> draft.key end)
  end

  def current_tab_fields(current_tab),
    do: @tab_fields |> Map.get(current_tab, [])

  def magnifier, do: @magnifier
end
