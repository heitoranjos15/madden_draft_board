defmodule MaddenDraft.View.Command.Cursor do
  def next(model), do: change_position(model, Kernel.+(model.cursor.x, 1))

  def next(model, :last), do: change_position(model, tab_field_limit(model))

  def previous(model), do: change_position(model, Kernel.-(model.cursor.x, 1))

  def previous(model, :first), do: change_position(model, 0)

  defp change_position(model, new_position) do
    limit = tab_field_limit(model)

    # IO.puts(new_position)

    cursor_pos =
      cond do
        limit < new_position -> 0
        new_position < 0 -> limit
        true -> new_position
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
