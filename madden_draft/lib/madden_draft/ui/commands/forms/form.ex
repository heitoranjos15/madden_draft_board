defmodule MaddenDraft.View.Command.Form do
  require Logger
  @behaviour Ratatouille.App

  @max_size 12

  import Ratatouille.View

  alias MaddenDraft.View.Helpers.Styles

  def generate(model, title, fields, column_size) do
    row do
      column(size: 12) do
        generate_form(model, fields, %{:title => title, :column_size => column_size})
      end
    end
  end

  defp create_field(model, size, name),
    do:
      column([size: size], [
        label(),
        panel(
          Styles.get_style(
            :panel,
            model.cursor.label_focus === name,
            Atom.to_string(name)
          ),
          [
            label(
              Styles.get_style(
                :label,
                model.cursor.label_focus === name,
                get_in(model, [:form_data, model.current_tab.name(), name])
              )
            )
          ]
        )
      ])

  defp generate_form(_, [], form_details, content, _, _, _) do
    panel(title: form_details.title) do
      for row_content <- content do
        row(row_content)
      end
    end
  end

  defp generate_form(model, field, form_details, content, column_count, row, limit_per_row)
       when column_count >= limit_per_row do
    new_row = Kernel.+(row, 1)
    new_content = List.insert_at(content, new_row, [])
    generate_form(model, field, form_details, new_content, 0, new_row, limit_per_row)
  end

  defp generate_form(
         model,
         [field | tail],
         form_details,
         content,
         column_count,
         row,
         limit_per_row
       )
       when column_count < limit_per_row do
    %{:column_size => size} = form_details

    row_content =
      content
      |> Enum.at(row)
      |> List.flatten([create_field(model, size, field)])

    new_content = List.replace_at(content, row, row_content)

    column_count = Kernel.+(column_count, 1)

    generate_form(model, tail, form_details, new_content, column_count, row, limit_per_row)
  end

  defp generate_form(model, fields, form_details) do
    %{:column_size => size} = form_details
    limit_per_row = Kernel.div(@max_size, size)
    generate_form(model, fields, form_details, [[]], 0, 0, limit_per_row)
  end
end
