defmodule MaddenDraft.View do
  @callback get_spec(spec_name :: String.t()) :: any()
  @callback spec() :: Map.t()
  @callback fields() :: List.t()
  @callback name() :: Atom.t()
  @callback render(model :: Map.t()) :: Ratatouille.Renderer.Element.t()
end
