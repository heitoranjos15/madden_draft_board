defmodule MaddenDraft.View.Components.Form.Action do
  alias MaddenDraft.View.Components.Form.{
    AddBoard
  }

  def build_page(model, tab) do
    case tab do
      :add_board -> AddBoard.render(model)
      _ -> model
    end
  end

  def save(model) do
    %{current_tab: tab} = model

    case tab do
      :add_board -> AddBoard.save(model)
    end

    Kernel.put_in(model, [:form_data, :status], "saved")
  end
end
