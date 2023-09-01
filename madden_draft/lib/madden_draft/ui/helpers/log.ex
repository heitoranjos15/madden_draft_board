defmodule MaddenDraft.View.Helpers.Log do
  def debug(model, message) when is_integer(message),
    do: debug(model, Integer.to_string(message))

  def debug(model, message) when is_atom(message),
    do: debug(model, Atom.to_string(message))

  def debug(model, message), do: %{model | debug: message}
end
