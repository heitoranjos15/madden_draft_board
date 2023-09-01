defmodule MaddenDraft.View.Command.Cursor do
  def next(model), do: change_position(model, Kernel.+(model.cursor.x, 1))

  def next(model, :last), do: change_position(model, tab_field_limit(model))

  def previous(model), do: change_position(model, Kernel.-(model.cursor.x, 1))

  def previous(model, :first), do: change_position(model, 0)

  defp change_position(model, new_position) do
    limit = tab_field_limit(model)
    begin = 0

    cursor_new_position =
      cond do
        limit < new_position -> begin
        new_position < begin -> limit
        true -> new_position
      end

    %{
      model
      | cursor: %{x: cursor_new_position, label_focus: label_focused(model, cursor_new_position)}
    }
  end

  def label_focused(model, new_position) when is_number(new_position) do
    %{current_tab: current_tab} = model

    Enum.at(get_tab_fields(current_tab, model), new_position)
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
