defmodule MaddenDraft.Boundary.BoardManager do
  use GenServer

  require Logger

  alias MaddenDraft.Core.Board
  alias MaddenDraft.Boundary.PlayerManager

  def start_link(opts \\ []) do
    state = opts[:players] || []
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def lazy_player(server \\ __MODULE__) do
    GenServer.cast(server, {:lazy_player})
  end

  def add_player_to_board(server \\ __MODULE__, player) do
    GenServer.call(server, {:add_player_to_board, player})
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

  def handle_cast({:lazy_player}, _state) do
    players =
      [
        %{name: "Trey Lance", age: 19, position: "QB", round_expected: 1, college: "NDSU"},
        %{
          name: "Trevor Lawrence",
          age: 22,
          position: "QB",
          round_expected: 1,
          college: "Clemson"
        },
        %{name: "Zach Wilson", age: 24, position: "QB", round_expected: 1, college: "BYU"},
        %{name: "Najee Haris", age: 24, position: "RB", round_expected: 1, college: "Alabama"},
        %{name: "Mac Jones", age: 24, position: "QB", round_expected: 2, college: "Alabama"},
        %{
          name: "Micah Parsons",
          age: 24,
          position: "ROLB",
          round_expected: 1,
          college: "Pen State"
        },
        %{name: "David Mills", age: 24, position: "QB", round_expected: 4, college: "Stanford"}
      ]
      |> Enum.map(&upsert_player_board(&1))
      |> Enum.map_reduce(0, fn player, acc -> 
        player_data = %{player_id: player.id, rank: acc, status: :available }
        { player_data, acc + 1 }
      end)
      |> fn { players, _acc } -> players end.()
      |> Enum.map(fn player -> 
        case Board.new(player) do
          {:ok, board_player} -> board_player
        end
      end)

    {:noreply, players}
  end

  def handle_call({:add_player_to_board, player}, _from, state) do
    player_data = upsert_player_board(player)

    player_data
    |> inspect()
    |> Logger.debug()
    
    attributes = %{player_id: player_data.id, rank: length(state), status: :available}

    attributes
    |> Board.new()
    |> case do
      {:ok, board_player} -> {:reply, :ok, [board_player | state]}
      _ -> {:reply, :ok, state}
    end
  end

  def handle_call({:show}, _from, state) do
    state_with_player =
      state
      |> Enum.map(fn board_player ->
        player_data = PlayerManager.find_player(:id, board_player.player_id)
        Map.put(board_player, :player, player_data)
      end)

    {:reply, state_with_player, state}
  end

  def handle_call({:player_rank, player_id, choose}, _from, state) do
    player_id
    |> Board.change_board_player_rank(choose, state)
    |> case do
      {:ok, updated_board} -> {:reply, :ok, updated_board}
      _ -> {:reply, :error, state}
    end
  end

  defp upsert_player_board(player_attributes) do
    player_data = PlayerManager.find_player(:name, player_attributes.name)

    if player_data do
      player_data
    else
      PlayerManager.add_player(player_attributes)
    end
  end
end
