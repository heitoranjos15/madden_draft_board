defmodule MaddenDraft.View.Components.FormAction do
  require Logger

  alias MaddenDraft.View.Commands.{
    BoardCommand,
    PlayerCommand
  }

  def save(model) do
    %{current_tab: tab} = model

    case tab do
      :add_board -> BoardCommand.save(model)
      :add_player -> PlayerCommand.save(model)
    end

    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
