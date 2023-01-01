defmodule MaddenDraft.View.App do
  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Runtime.Command

  import MaddenDraft.View.Helpers.Shortcuts

  alias MaddenDraft.View.Components.{
    Bars,
    Home,
    Form
  }

  alias MaddenDraft.View.Helpers.TextMode

  def init(_context) do
    model = %{
      current_tab: :home,
      page: :home,
      text_mode: false,
      draft_form: %{
        name: "",
        already_exist: false
      },
      form_data: %{
        add_board: %{
          madden: "Heitor",
          year: "",
          team: "",
          team_needs: "",
          picks: ""
        }
      },
      text_value: "",
      cursor: %{
        y: 0,
        x: 0,
        label_focus: :none
      },
      status: :normal
    }

    model
  end

  def update(model, msg) do
    case {model, msg} do
      {%{text_mode: true}, message} ->
        TextMode.render_text(model, message)

      {_, {:event, %{key: key, ch: ch}}} ->
        shortcuts(model, key, ch)

      _ ->
        model
    end
  end

  def render(model) do
    top_bar = Bars.Top.render(model)
    bottom_bar = Bars.Bottom.render(model)

    view(top_bar: top_bar, bottom_bar: bottom_bar) do
      tabs(model)
    end
  end

  def tabs(model) do
    case model.current_tab do
      :add_board -> Form.render(model, :add_board)
      _ -> Home.render(model)
    end
  end
end

Ratatouille.run(MaddenDraft.View.App)
