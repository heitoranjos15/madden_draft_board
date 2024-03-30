defmodule MaddenDraft.View.Command.Select do
  import Ratatouille.Constants, only: [key: 1]
  alias MaddenDraft.View.Helpers.ActionHelper
  @escape key(:esc)
  @enter key(:enter)

  def action(model, message) do
    %{current_tab: tab} = model
    %{selection: bindings} = tab.get_spec(:bindings).()
    {_, %{key: key, ch: ch}} = message
    action_binding = ActionHelper.get_action_by_key_pressed(bindings, key, ch)

    cond do
      key == @escape -> %{model | status: :normal}
      key == @enter -> %{model | status: :normal}
      action_binding -> action_binding.(model)
      true -> model
    end
  end
end
