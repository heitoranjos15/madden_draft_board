defmodule MaddenDraft.View.Components.Form do
  require Logger

  alias MaddenDraft.View.Components.Form.{
    AddBoard
  }

  alias MaddenDraft.View.Commands.BoardCommand

  def render(model, tab) do
    case tab do
      :add_board -> AddBoard.render(model)
    end
  end

  def save(model) do
    %{current_tab: tab} = model

    case tab do
      :add_board -> BoardCommand.save(model)
    end

    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
