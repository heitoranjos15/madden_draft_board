defmodule MaddenDraft.View.App do
  @behaviour Ratatouille.App

  import Ratatouille.View

  alias MaddenDraft.View.Command.Bindings

  alias MaddenDraft.View.Board

  alias MaddenDraft.View.Components.{
    Bars,
    Home
  }

  alias MaddenDraft.View.Command.TextMode

  def init(_context) do
    model = %{
      current_tab: Home,
      current_page: Home,
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
        add_player: %{
          name: "Heitor",
          position: "",
          age: "",
          college: "",
          expected: ""
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
      :home -> Home.render(model)
      :board -> Board.render(model)
      _ -> Home.render(model)
    end
  end
end

# Ratatouille.run(MaddenDraft.View.App)
