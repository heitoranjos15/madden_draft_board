defmodule MaddenDraft.View.Components.Bars.Bottom do
  import Ratatouille.View
  import Ratatouille.Constants, only: [attribute: 1]

  @style_selected [
    attributes: [attribute(:bold)]
  ]

  def render(model) do
    bar do
      label do
        text(content: "<<<")
        text(@style_selected ++ [content: Atom.to_string(model.page)])
        text(content: ">>>")
        text(content: "<<<")
        text(@style_selected ++ [content: Atom.to_string(model.status)])
        text(content: ">>>")
      end
    end
  end
end
