defmodule MaddenDraft.View.Helpers.ActionHelper do
  def get_action_by_key_pressed(actions, key, ch) do
    action = Map.get(actions, ch)

    if action do
      action
    else
      Map.get(actions, key)
    end
  end
end
