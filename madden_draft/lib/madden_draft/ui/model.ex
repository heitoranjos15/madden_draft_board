defmodule MaddenDraft.View do
  @callback fields() :: List.t()
  @callback name() :: Atom.t()
  @callback render(model :: Map.t()) :: Ratatouille.Renderer.Element.t()
end
