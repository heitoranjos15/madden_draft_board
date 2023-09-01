defmodule MaddenDraft.View.Command.TextMode do
  import Ratatouille.Constants, only: [key: 1]

  alias MaddenDraft.View.Command.Cursor

  @space_bar key(:space)

  @escape key(:esc)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  def render_text(model, message) do
    case message do
      {:event, %{key: @escape}} ->
        %{model | status: :normal}

      _ ->
        {_, label_path, text} = get_label_by_cursor(model)

        put_in(model, [:form_data | label_path], update_text(text, message))
    end
  end

  def get_label_by_cursor(model) do
    %{
      current_tab: current_tab,
      form_data: form_data
    } = model

    label = Cursor.label_focused(model)

    label_path = [current_tab.get_spec(:name), label]

    text = get_in(form_data, label_path)

    {label, label_path, text}
  end

  def update_text(text, message) do
    case message do
      {:event, %{key: key}} when key in @delete_keys ->
        String.slice(text, 0..-2)

      {:event, %{key: @space_bar}} ->
        text <> " "

      {:event, %{ch: ch}} ->
        text <> <<ch::utf8>>
    end
  end
end
