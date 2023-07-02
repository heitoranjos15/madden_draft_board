defmodule MaddenDraft.View.Command.Form.Data do
  alias MaddenDraft.View.Components.{
    AddBoard,
    AddPlayer
  }

  def form_data() do
    modules = [AddPlayer, AddBoard]
    Map.new(modules, fn module -> set_module_data(module) end)
  end

  defp set_module_data(module) do
    fields = module.fields
    name = module.name
    mapped_fields = Map.new(fields, fn field -> {field, ""} end)
    {name, mapped_fields}
  end
end
