defmodule MaddenDraft.View.App do
  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Runtime.Command

  alias MaddenDraft.View.Helpers.Bindings

  alias MaddenDraft.View.Board

  alias MaddenDraft.View.Components.{
    Bars,
    Home,
    Form
  }

  alias MaddenDraft.View.Helpers.TextMode

  def init(_context) do
    model = %{
      current_tab: :home,
      current_page: :home,
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
        },
        status: "unsaved"
      },
      text_value: "",
      cursor: %{
        y: 0,
        x: 0,
        label_focus: :none
      },
      draft_selected: "",
      status: :normal
    }

    model
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
      get_page(model)
    end
  end

  def get_page(model) do
    case model.current_page do
      :home -> tabs_home(model)
      :board -> Board.render(model)
      _ -> tabs_home(model)
    end
  end

  def tabs_home(model) do
    case model.current_tab do
      :add_board -> Form.render(model, :add_board)
      _ -> Home.render(model, :home)
    end
  end
end

# Ratatouille.run(MaddenDraft.View.App)
