defmodule MaddenDraft.Boundary.BoardManager do
  use GenServer

  require Logger

  alias MaddenDraft.Core.Board

  def start_link(opts \\ []) do
    state = opts[:players] || []
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def add_player_to_board(server \\ __MODULE__, player) do
    GenServer.cast(server, {:add_player_to_board, player})
  end

  def show(server \\ __MODULE__) do
    GenServer.call(server, {:show})
  end

  def player_rank(server \\ __MODULE__, player_id, choose) do
    GenServer.call(server, {:player_rank, player_id, choose})
  end
    
    
  def init(state) do
    {:ok, state}
  end


  def handle_cast({:add_player_to_board, player}, state) do
    attributes = %{player_id: player.id, rank: length(state), status: :available}

    attributes
    |> Board.new
    |> case do
      {:ok, board_player } -> {:noreply, [board_player | state]}
      _ -> {:noreply, state }
    end
  end

  def handle_call({:show }, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:player_rank, player_id, choose}, _from, state) do
    player_id
    |> Board.change_board_player_rank(choose, state)
    |> case do
      {:ok, updated_board } -> {:reply, :ok, updated_board }
      _ -> {:reply, :error, state }
    end
  end
end
