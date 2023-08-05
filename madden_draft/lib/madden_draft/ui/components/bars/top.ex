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
      {:add_player, "[A]dd player"},
      {:edit_player, "[E]dit player"}
    ]
  }
  @style_selected [
    attributes: [attribute(:bold)]
  ]

  def render(model) do
    bar do
      label do
        render_tabs(model)
      end
    end
  end

  defp render_tabs(model) do
    %{current_page: page, current_tab: tab} = model
    tab_list = page.get_spec(:tabs)
    current_tab_name = tab.get_spec(:name)

    rendered_options =
      for {key, label} <- tab_list do
        if key == current_tab_name do
          text(@style_selected ++ [content: label])
        else
          text(content: label)
        end
      end

    Enum.intersperse(rendered_options, text(content: "  "))
  end
end
