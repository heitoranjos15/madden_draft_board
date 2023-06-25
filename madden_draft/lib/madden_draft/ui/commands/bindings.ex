defmodule MaddenDraft.View.Command.Bindings do
  import Ratatouille.Constants, only: [key: 1]
  alias MaddenDraft.View.Command.Cursor
  alias MaddenDraft.View.Command.Form.Action

  @global_keymaps [
    {key(:tab), {:move_cursor, :next}},
    {key(:esc), {:text_mode, :exit}},
    {?j, {:move_cursor, :next}},
    {?k, {:move_cursor, :previous}},
    {?0, {:move_cursor, :first}},
    {?$, {:move_cursor, :last}},
    {key(:enter), :enter}
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
     ]},
    {:board,
     [
       {:vertical,
        %{
          ?b => {:page, :home, :home},
          ?c => {:tab, :add_player}
        }},
       {:horizontal,
        %{
          ?b => {:page, :home, :home},
          ?c => {:tab, :add_player}
        }},
       {:add_player,
        %{
          ?b => {:page, :home, :home},
          ?h => {:tab, :horizontal},
          ?a => {:text_mode, :start},
          ?c => {:text_mode, :clean},
          ?w => :save,
          ?q => :quit
        }}
     ]}
  ]

  def run(model, key, ch) do
    page = Map.get(model, :current_page)

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
      {:page, page, tab} -> page_change(model, page, tab)
      :enter -> tab_enter(model)
      :save -> Action.save(model)
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

  defp page_change(model, page, tab) do
    %{
      model
      | current_page: page,
        current_tab: tab,
        cursor: %{label_focus: Cursor.label_focused(tab, 0), x: 0, y: 0}
    }
  end

  defp tab_change(model, tab_selected) do
    new_model = Kernel.put_in(model, [:form_data, :status], "unsaved")

    %{
      new_model
      | current_tab: tab_selected,
        cursor: %{label_focus: Cursor.label_focused(tab_selected, 0), x: 0, y: 0}
    }
  end

  defp tab_enter(model) do
    current_tab = model.current_tab

    case current_tab do
      :home -> select_draft(model)
      _ -> model
    end
  end

  defp select_draft(model) do
    new_model = page_change(model, :board, :horizontal)

    %{
      new_model
      | draft_selected: model.cursor.label_focus
    }
  end

  defp move_cursor(model, action) do
    case action do
      :first -> Cursor.previous(model, 0)
      :previous -> Cursor.previous(model)
      :next -> Cursor.next(model)
      :last -> Cursor.next(model, :last)
    end
  end
end
