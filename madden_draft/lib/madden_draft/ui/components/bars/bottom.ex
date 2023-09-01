defmodule MaddenDraft.View.Components.Bars.Bottom do
  import Ratatouille.View
  import Ratatouille.Constants, only: [attribute: 1]

  @style_selected [
    attributes: [attribute(:bold)]
  ]

  def render(model) do
    %{current_page: page, debug: debug, error: error, status: status} = model
    name = page.get_spec(:name)

    bar do
      label do
        text(content: "<<<")
        text(@style_selected ++ [content: Atom.to_string(name)])
        text(content: ">>>")
        text(content: "<<<")
        text(@style_selected ++ [content: Atom.to_string(status)])
        text(content: ">>>")

        if debug != "" do
          text(content: "DEBUG")
          text(@style_selected ++ [content: debug])
        end

        if error != "" do
          text(content: "<<<< ERROR >>>")
          text(@style_selected ++ [content: error])
        end
      end
    end
  end
end
