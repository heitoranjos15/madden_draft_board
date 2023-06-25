defmodule MaddenDraft.View.Helpers.Styles do
  import Ratatouille.Constants, only: [color: 1]

  defguard component_type(component, param) when component === param

  def selected_style(component, content) when component_type(component, :label),
    do: [
      color: color(:black),
      background: color(:white),
      content: content
    ]

  def selected_style(component, title) when component_type(component, :panel),
    do: [
      color: color(:black),
      background: color(:white),
      title: title
    ]

  def default_style(component, content) when component_type(component, :label),
    do: [
      color: color(:white),
      background: color(:black),
      content: content
    ]

  def default_style(component, title) when component_type(component, :panel),
    do: [
      color: color(:white),
      title: title
    ]

  def get_style(component, selected_condition, nil),
    do: get_style(component, selected_condition, "")

  def get_style(component, selected_condition, content) do
    if selected_condition do
      selected_style(component, content)
    else
      default_style(component, content)
    end
  end
end
