defmodule MaddenDraft.View.Command.Cursor do
  def next(model), do: next(model, model.cursor.x + 1)

  def next(model, :last), do: next(model, tab_field_limit(model))

  def next(model, position) do
    cursor_pos =
      if tab_field_limit(model) < position do
        0
      else
        position
      end

    %{model | cursor: %{x: cursor_pos, label_focus: label_focused(model)}}
  end

  def previous(model), do: previous(model, model.cursor.x - 1)

  def previous(model, position) do
    cursor_pos =
      if position < 0 do
        tab_field_limit(model)
      else
        position
      end

    %{model | cursor: %{x: cursor_pos, label_focus: label_focused(model)}}
  end

  def label_focused(model, tab_selected) do
    Enum.at(tab_selected.fields(model), 0)
  end

  def label_focused(model) do
    %{current_tab: current_tab, cursor: %{x: cursor_position}} = model

    Enum.at(current_tab.fields(model), cursor_position)
  end

  defp tab_field_limit(model) do
    %{current_tab: tab} = model

    tab.fields(model) |> length |> Kernel.-(1)
  end
end
