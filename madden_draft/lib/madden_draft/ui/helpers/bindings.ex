defmodule MaddenDraft.View.Helpers.Bindings do
  import Ratatouille.Constants, only: [key: 1]
  alias MaddenDraft.View.Components.Cursor

  @global_keymaps [
    {key(:tab), {:move_cursor, :next}},
    {key(:esc), {:text_mode, :exit}},
    {?j, {:move_cursor, :next}},
    {?k, {:move_cursor, :previous}},
    {?0, {:move_cursor, :first}},
    {?$, {:move_cursor, :last}}
  ]

  @page_tabs_shortcuts [
    {:home,
     [
       {:home,
        %{
          ?h => {:tab, :home},
          ?a => {:tab, :add_board},
          ?s => {:tab, :search_board}
        }},
       {:add_board,
        %{
          ?h => {:tab, :home},
          ?s => {:tab, :search_board},
          ?a => {:text_mode, :start},
          ?c => {:text_mode, :clean},
          ?w => :save,
          ?q => :quit
        }}
     ]}
  ]

  def run(model, key, ch) do
    page = Map.get(model, :page)

    tab_command =
      @page_tabs_shortcuts |> Keyword.get(page) |> Keyword.get(model.current_tab) |> Map.get(ch)

    if tab_command do
      action_shortcut(model, tab_command)
    else
      get_global_action(model, key, ch)
    end
  end

  defp get_global_action(model, key, ch) do
    {_, global_action_keymap} =
      Enum.find(@global_keymaps, {nil, false}, fn {key_pressed, _} ->
        key_pressed == key or key_pressed == ch
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
      :save -> model
      :quit -> model
      _ -> model
    end
  end

  defp text_mode_action(model, action) do
    case action do
      :start -> %{model | text_mode: true, status: :text_mode}
      :clean -> %{model | text_mode: true, status: :text_mode}
      :exit -> %{model | text_mode: false, status: :normal}
      _ -> model
    end
  end

  defp tab_change(model, tab_selected),
    do: %{
      model
      | current_tab: tab_selected,
        cursor: %{label_focus: Cursor.label_focused(tab_selected, 0), x: 0, y: 0}
    }

  defp move_cursor(model, action) do
    case action do
      :first -> Cursor.previous(model, 0)
      :previous -> Cursor.previous(model)
      :next -> Cursor.next(model)
      :last -> Cursor.next(model, :last)
    end
  end
end
