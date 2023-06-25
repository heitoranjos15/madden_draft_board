defmodule MaddenDraft.View.Command.Form.Action do
  require Logger

  alias MaddenDraft.View.Integration.{
    BoardIntegration,
    PlayerIntegration
  }

  def save(model) do
    %{current_tab: tab} = model

    case tab do
      :add_board -> BoardIntegration.save(model)
      :add_player -> PlayerIntegration.save(model)
    end

    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
