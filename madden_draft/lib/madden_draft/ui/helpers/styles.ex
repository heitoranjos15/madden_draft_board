defmodule MaddenDraft.View.Helpers.Styles do
  import Ratatouille.Constants, only: [color: 1]

  def pannel_selected_bg(title),
    do: [
      color: color(:black),
      background: color(:white),
      title: Atom.to_string(title)
    ]

  def pannel_normal_bg(title),
    do: [
      color: color(:white),
      title: Atom.to_string(title)
    ]

  def label_select_bg(content),
    do: [
      color: color(:black),
      background: color(:white),
      content: content
    ]

  def label_normal_bg(content),
    do: [
      color: color(:white),
      background: color(:black),
      content: content
    ]
end
