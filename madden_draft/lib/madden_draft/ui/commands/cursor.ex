defmodule MaddenDraft.View.Command.Cursor do
  alias MaddenDraft.View.Command.Form.Fields

  def next(model), do: next(model, model.cursor.x + 1)

  def next(model, :last), do: next(model, Fields.current_tab_field_limit(model))

  def next(model, position) do
    cursor_pos =
      if Fields.current_tab_field_limit(model) < position do
        0
      else
        position
      end

    %{model | cursor: %{x: cursor_pos, label_focus: label_focused(model.current_tab, cursor_pos)}}
  end

  def previous(model), do: previous(model, model.cursor.x - 1)

  def previous(model, position) do
    cursor_pos =
      if position < 0 do
        Fields.current_tab_field_limit(model)
      else
        position
      end

    %{model | cursor: %{x: cursor_pos, label_focus: label_focused(model.current_tab, cursor_pos)}}
  end

  def label_focused(%{current_tab: current_tab, cursor: %{x: cursor_position}}),
    do: label_focused(current_tab, cursor_position)

  def label_focused(current_tab, cursor_position) do
    current_tab
    |> Fields.current_tab_fields()
    |> Enum.at(cursor_position)
  end
end
