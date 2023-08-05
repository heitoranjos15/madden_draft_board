defmodule MaddenDraft.View.Components.Bars.Bottom do
  import Ratatouille.View
  import Ratatouille.Constants, only: [attribute: 1]

  @style_selected [
    attributes: [attribute(:bold)]
  ]

  def render(model) do
    %{current_page: page} = model
    name = page.get_spec(:name)

    bar do
      label do
        text(content: "<<<")
        text(@style_selected ++ [content: Atom.to_string(name)])
        text(content: ">>>")
        text(content: "<<<")
        text(@style_selected ++ [content: Atom.to_string(model.status)])
        text(content: ">>>")
      end
    end
  end
end
