defmodule MaddenDraft.View.Components.Home do
  @behaviour MaddenDraft.View

  @logo "
 ▄▄   ▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄  ▄▄▄▄▄▄  ▄▄▄▄▄▄▄ ▄▄    ▄    ▄▄▄▄▄▄  ▄▄▄▄▄▄   ▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄
█  █▄█  █      █      ██      ██       █  █  █ █  █      ██   ▄  █ █      █       █       █
█       █  ▄   █  ▄    █  ▄    █    ▄▄▄█   █▄█ █  █  ▄    █  █ █ █ █  ▄   █    ▄▄▄█▄     ▄█
█       █ █▄█  █ █ █   █ █ █   █   █▄▄▄████   ██  █ ███   █   █▄▄█▄█ █▄█  █   █▄▄▄  █   ██ ██
█       █      █ █▄█   █ █▄█   █    ▄▄▄████   ██  █ ███   █    ▄▄  █      █    ▄▄▄█ █   ██ ██
█ ██▄██ █  ▄   █       █       █   █▄▄▄█ █ █   █  █       █   █  █ █  ▄   █   █     █   █
█▄█   █▄█▄█ █▄▄█▄▄▄▄▄▄██▄▄▄▄▄▄██▄▄▄▄▄▄▄█▄█  █▄▄█  █▄▄▄▄▄▄██▄▄▄█  █▄█▄█ █▄▄█▄▄▄█     █▄▄▄█
"

  require Logger
  import Ratatouille.View
  alias MaddenDraft.View.Integration.BoardIntegration
  alias MaddenDraft.View.Helpers.Styles
  alias MaddenDraft.View.Components.AddBoard
  alias MaddenDraft.View.Components.Board

  def render(model) do
    case model.current_tab.name do
      :home -> home_page(model)
      _ -> model.current_tab.render(model)
    end
  end

  def name, do: :home

  def tabs, do: [{:home, "[H]ome"}, {:add_board, "[A]dd"}, {:search, "[S]earch"}]

  def bindings,
    do: %{
      ?h => {:tab, MaddenDraft.View.Components.Home},
      ?a => {:tab, AddBoard}
      # ?s => {:tab, :search_board}
    }

  def fields,
    do:
      BoardIntegration.list_boards()
      |> Enum.map(fn draft -> draft.key end)

  defp home_page(model) do
    row do
      column(size: 12) do
        label(content: @logo)

        panel(Styles.default_style(:panel, "Drafts")) do
          build_list_drafts(model)
        end
      end
    end
  end

  def build_list_drafts(model) do
    for draft <- BoardIntegration.list_boards() do
      draft_name = draft.key

      label(Styles.get_style(:label, model.cursor.label_focus === draft_name, draft_name))
    end
  end

  def redirect, do: [Board, Board]
end
