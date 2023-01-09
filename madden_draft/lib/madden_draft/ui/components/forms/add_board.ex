defmodule MaddenDraft.View.Components.Form.AddBoard do
  @behaviour Ratatouille.App

  import Ratatouille.View

  alias MaddenDraft.View.Helpers.Styles
  alias MaddenDraft.Boundary.DraftSupervisor
  alias MaddenDraft.Boundary.BoardManager

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

  def save(model) do
    board_data = Kernel.get_in(model, [:form_data, :add_board, :madden])
    DraftSupervisor.create_board(board_data)
    BoardManager.lazy_player(board_data)
  end

  def render(model) do
    form_data = form_fields()

    row do
      column(size: 12) do
        panel(title: form_data) do
          for field <- form_data.fields do
            row do
              column(size: 12) do
                label(content: "allloo")

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

    label(content: "ALLLOOOO")
    label(content: get_in(model, [:form_data, :add_board, :status]))
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
