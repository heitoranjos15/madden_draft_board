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
  import Ratatouille.Constants, only: [key: 1]
  import Ratatouille.View
  alias MaddenDraft.View.Integration.BoardIntegration
  alias MaddenDraft.View.Helpers.Styles
  alias MaddenDraft.View.Components.AddBoard

  def render(model) do
    case model.current_tab.get_spec(:name) do
      :home -> home_page(model)
      _ -> model.current_tab.render(model)
    end
  end

  def get_spec(attr_name), do: Map.get(spec(), attr_name)

  def spec do
    %{
      :name => :home,
      :tabs => [{:home, "[H]ome"}, {:add_board, "[A]dd"}, {:search, "[S]earch"}],
      :bindings => &bindings/0,
      :fields => &fields/1
    }
  end

  defp bindings,
    do: %{
      ?h => {:tab, MaddenDraft.View.Components.Home},
      ?a => {:tab, AddBoard},
      key(:enter) =>
        {:page,
         [
           MaddenDraft.View.Components.Board,
           MaddenDraft.View.Components.Board
         ]}
      # ?s => {:tab, :search_board}
    }

  defp fields(_),
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

  defp build_list_drafts(model) do
    for draft <- BoardIntegration.list_boards() do
      draft_name = draft.key

      label(Styles.get_style(:label, model.cursor.label_focus === draft_name, draft_name))
    end
  end
end
