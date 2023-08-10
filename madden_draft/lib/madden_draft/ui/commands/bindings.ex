defmodule MaddenDraft.View.Command.Bindings do
  import Ratatouille.Constants, only: [key: 1]
  require Logger
  alias MaddenDraft.View.Command.Cursor
  alias MaddenDraft.View.Command.Form.Action
  alias MaddenDraft.View.Helpers.ActionHelper

  @global_keymaps [
    {key(:tab), {:move_cursor, :next}},
    {key(:esc), {:text_mode, :exit}},
    {?j, {:move_cursor, :next}},
    {?k, {:move_cursor, :previous}},
    {?0, {:move_cursor, :first}},
    {?$, {:move_cursor, :last}},
    {key(:enter), :enter_key}
  ]

  def run(model, key, ch) do
    %{current_page: page, current_tab: tab} = model

    page_bindings = page.get_spec(:bindings).()
    tab_bindings = tab.get_spec(:bindings).()

    page_command = ActionHelper.get_action_by_key_pressed(page_bindings, key, ch)
    tab_command = ActionHelper.get_action_by_key_pressed(tab_bindings, key, ch)

    cond do
      tab_command -> action_shortcut(model, tab_command)
      page_command -> action_shortcut(model, page_command)
      true -> get_global_action(model, key, ch)
    end
  end

  defp get_global_action(model, key, ch) do
    {_, global_action_keymap} =
      Enum.find(@global_keymaps, {nil, false}, fn {key_binding, _} ->
        key_binding == key or key_binding == ch
      end)

    if global_action_keymap do
      action_shortcut(model, global_action_keymap)
    else
      model
    end
  end

  defp action_shortcut(model, shortcut) do
    case shortcut do
      {:text_mode, action} -> text_mode_action(model, action)
      {:tab, tab_selected} -> tab_change(model, tab_selected)
      {:move_cursor, action} -> move_cursor(model, action)
      {:page, redirect} -> page_change(model, redirect)
      {:select} -> select(model)
      :save -> Action.save(model)
      :quit -> model
      _ -> model
    end
  end

  defp text_mode_action(model, action) do
    case action do
      :start -> %{model | status: :text_mode}
      :clean -> %{model | status: :text_mode}
      :exit -> %{model | status: :normal}
      _ -> model
    end
  end

  defp page_change(model, redirect) do
    [page, tab] = redirect

    %{
      model
      | current_page: page,
        current_tab: tab,
        cursor: %{label_focus: Cursor.label_focused(model, tab), x: 0, y: 0},
        draft_selected: model.cursor.label_focus
    }
  end

  defp tab_change(model, tab_selected) do
    new_model = Kernel.put_in(model, [:form_data, :status], "unsaved")

    %{
      new_model
      | current_tab: tab_selected,
        cursor: %{label_focus: Cursor.label_focused(new_model, tab_selected), x: 0, y: 0}
    }
  end

  defp move_cursor(model, action) do
    case action do
      :first -> Cursor.previous(model, :first)
      :previous -> Cursor.previous(model)
      :next -> Cursor.next(model)
      :last -> Cursor.next(model, :last)
    end
  end

  defp select(model) do
    new_model = Kernel.put_in(model, [:debug], Integer.to_string(model.cursor.label_focus))

    %{new_model | status: :selection}
  end
end
