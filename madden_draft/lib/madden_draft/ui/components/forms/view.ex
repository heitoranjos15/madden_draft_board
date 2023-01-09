defmodule MaddenDraft.View.Components.Form.View do
  @behaviour Ratatouille.App

  import Ratatouille.View

  alias MaddenDraft.View.Helpers.Styles

  def render(model, add_page) do
    case add_page do
      :add_board -> form_boards(model)
    end
  end

  def form_fields() do
    %{
      title: "Add Board",
      fields: [
        :madden,
        :year,
        :team,
        :team_needs,
        :picks
      ]
    }
  end

  defp form_boards(model) do
    form_data = form_fields()

    row do
      column(size: 12) do
        panel(title: form_data) do
          for field <- form_data.fields do
            row do
              column(size: 12) do
                label()

                panel(get_panel_style(model, field)) do
                  label(
                    get_label_style(
                      model,
                      field,
                      get_in(model, [:form_data, :add_board, field])
                    )
                  )
                end
              end
            end
          end
        end
      end
    end
  end

  defp get_panel_style(model, title) do
    if model.cursor.label_focus === title do
      Styles.pannel_selected_bg(title)
    else
      Styles.pannel_normal_bg(title)
    end
  end

  defp get_label_style(model, field, content) do
    if model.cursor.label_focus === field do
      Styles.label_select_bg(content)
    else
      Styles.label_normal_bg(content)
    end
  end
end
