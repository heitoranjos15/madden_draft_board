defmodule MaddenDraft.Boundary.DraftSupervisor do
  @moduledoc """
    Starts board creation for the current franchise draft
  """
  use DynamicSupervisor

  alias MaddenDraft.Boundary.BoardManager

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def create_board(name) do
    child_spec = %{
      id: BoardManager,
      start: {BoardManager, :start_link, [name]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
