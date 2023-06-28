defmodule MaddenDraft.View.App do
  @behaviour Ratatouille.App

  import Ratatouille.View
  require Logger

  alias MaddenDraft.View.Command.Bindings

  alias MaddenDraft.View.Components.{
    Bars,
    Home
  }

  alias MaddenDraft.View.Command.TextMode
  alias MaddenDraft.View.Command.Form.Data

  def init(_context) do
    model = %{
      current_tab: Home,
      current_page: Home,
      text_mode: false,
      form_data: %{},
      text_value: "",
      cursor: %{
        y: 0,
        x: 0,
        label_focus: :none
      },
      draft_selected: "",
      status: :normal
    }

    put_in(model, [:form_data], Data.form_data())
  end

  def update(model, msg) do
    case {model, msg} do
      {%{text_mode: true}, message} ->
        TextMode.render_text(model, message)

      {_, {:event, %{key: key, ch: ch}}} ->
        Bindings.run(model, key, ch)

      _ ->
        model
    end
  end

  def render(model) do
    top_bar = Bars.Top.render(model)
    bottom_bar = Bars.Bottom.render(model)

    view(top_bar: top_bar, bottom_bar: bottom_bar) do
      model.current_page.render(model)
    end
  end

  @magnifier "🔍"

  def magnifier, do: @magnifier
end

# Ratatouille.run(MaddenDraft.View.App)
