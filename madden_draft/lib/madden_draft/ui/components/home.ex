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

  @behaviour Ratatouille.App

  import Ratatouille.View

  alias MaddenDraft.View.Components.Form

  def render(model) do
    tabs(model)
  end

  defp home_page(model) do
    row do
      column(size: 12) do
        label(content: @logo)
        label(content: Atom.to_string(model.current_tab))
      end
    end
  end

  defp tabs(model) do
    case Map.get(model, :current_tab) do
      # :home -> home_page(model)
      # :add_board -> Form.render(model, :board)
      _ -> home_page(model)
    end
  end
end
