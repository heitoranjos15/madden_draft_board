defmodule MaddenDraft.View.Components.Form.AddBoard do
  @behaviour Ratatouille.App

  import Ratatouille.View

  require Logger

  alias MaddenDraft.View.Helpers.Styles

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

  def render(model) do
    form_data = form_fields()

    row do
      column(size: 12) do
        panel(title: form_data) do
          for field <- form_data.fields do
            row do
              column(size: 12) do
                label()

                panel(
                  Styles.get_style(
                    :panel,
                    model.cursor.label_focus === field,
                    Atom.to_string(field)
                  )
                ) do
                  label(
                    Styles.get_style(
                      :label,
                      model.cursor.label_focus === field,
                      get_in(model, [:form_data, :add_board, field])
                    )
                  )
                end
              end
            end
          end
        end

        label(content: get_in(model, [:form_data, :status]))
      end
    end
  end
end
