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
    Enum.at(get_tab_fields(tab_selected, model), 0)
  end

  def label_focused(model) do
    %{current_tab: current_tab, cursor: %{x: cursor_position}} = model

    Enum.at(get_tab_fields(current_tab, model), cursor_position)
  end

  defp tab_field_limit(model) do
    %{current_tab: tab} = model

    get_tab_fields(tab, model) |> length |> Kernel.-(1)
  end

  defp get_tab_fields(tab, model) do
    fields_fun = Map.get(tab.spec(), :fields, nil)

    if fields_fun do
      fields_fun.(model)
    else
      []
    end
  end
end
