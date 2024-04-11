defmodule MaddenDraft.Boundary.DraftSupervisor do
  @moduledoc """
    Starts board creation for the current franchise draft
  """
  use DynamicSupervisor

  alias MaddenDraft.Boundary.BoardManager
  alias MaddenDraft.Database.Repo
  alias MaddenDraft.Database.Schema.Board, as: Schema

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def create_board(name) do
    child_spec = %{
      id: name,
      start: {BoardManager, :start_link, [name]},
      restart: :transient
    }

    Repo.insert!(board_to_schema(name))
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def get_drafts do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.map(fn {_, board_pid, _, _} ->
      key =
        MaddenDraft.BoardRegistry
        |> Registry.keys(board_pid)
        |> Enum.at(0)

      %{pid: board_pid, key: key}
    end)
  end

  def board_to_schema(name) do
    %Schema{
      name: name,
      status: "active",
      players: [%{}]
    }
  end
end
