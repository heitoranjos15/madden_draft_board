defmodule MaddenDraft.View.Components.Bars.Top do
  import Ratatouille.View
  import Ratatouille.Constants, only: [attribute: 1]

  @page_tabs %{
    :home => [
      {:home, "[H]ome"},
      {:add_board, "[A]dd"},
      {:search, "[S]earch"}
    ],
    :board => [
      {:home, "[B]ack"},
      {:horizontal, "[H]orizontal"},
      {:vertical, "[V]ertical"},
      {:new_player, "[A]dd player"},
      {:edit_player, "[E]dit player"}
    ]
  }
  @style_selected [
    attributes: [attribute(:bold)]
  ]

  def render(model) do
    bar do
      label do
        render_tabs(model.current_page, model.current_tab)
      end
    end
  end

  defp render_tabs(current_page, current_tab) do
    tabs = Map.get(@page_tabs, current_page)

    rendered_options =
      for {key, label} <- tabs do
        if key == current_tab do
          text(@style_selected ++ [content: label])
        else
          text(content: label)
        end
      end

    Enum.intersperse(rendered_options, text(content: "  "))
  end
end
