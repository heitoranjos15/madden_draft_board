defmodule MaddenDraft.View.Components.Home do
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

  def render(model) do
    case model.current_tab do
      :home -> home_page(model)
      :add_board -> AddBoard.render(model)
      _ -> home_page(model)
    end
  end

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
end
