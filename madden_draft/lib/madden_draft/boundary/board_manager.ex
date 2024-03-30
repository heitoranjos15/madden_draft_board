defmodule MaddenDraft.Boundary.BoardManager do
  use GenServer

  require Logger

  alias MaddenDraft.Core.Board
  alias MaddenDraft.Boundary.PlayerManager

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: server(name))
  end

  def lazy_players(name) do
    GenServer.cast(server(name), {:lazy_players})
  end

  def add_player_to_board(name, player) do
    GenServer.call(server(name), {:add_player_to_board, player})
  end

  def show(name) do
    GenServer.call(server(name), {:show})
  end

  def update_player_rank(name, player_id, player_to_switch) do
    GenServer.call(server(name), {:update_player_rank, player_id, player_to_switch})
  end

  def filter_board(name, filter, value) do
    GenServer.call(server(name), {:filter_board, filter, value})
  end

  def filter_board_by_players(name, filter, value) do
    GenServer.call(server(name), {:filter_board_by_players, filter, value})
  end

  def edit_board(name, player_id, value) do
    GenServer.call(server(name), {:edit_board, player_id, value})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:lazy_players}, _state) do
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
      |> Enum.map(&find_or_create_player(&1))
      |> Enum.map_reduce(0, fn player, acc ->
        player_data = %{player_id: player.id, rank: acc, status: :available}
        {player_data, acc + 1}
      end)
      |> (fn {players, _acc} -> players end).()
      |> Enum.map(fn player ->
        case Board.new(player) do
          {:ok, board_player} -> board_player
        end
      end)

    {:noreply, players}
  end

  def handle_call({:add_player_to_board, player}, _from, state) do
    find_or_create_player(player)

    attributes = %{player_id: length(state), rank: length(state), status: :available}

    attributes
    |> Board.new()
    |> case do
      {:ok, board_player} -> {:reply, :ok, [board_player | state]}
      _ -> {:reply, :ok, state}
    end
  end

  def handle_call({:show}, _from, state) do
    {:reply, get_player_data(state), state}
  end

  def handle_call({:filter_board, filter, value}, _from, state) do
    board_filtered = state |> Board.filter_board(filter, value) |> get_player_data()
    {:reply, board_filtered, state}
  end

  def handle_call({:filter_board_by_players, filter, value}, _from, state) do
    players =
      get_player_data(state)
      |> Board.filter_board_by_players(filter, value)

    {:reply, players, state}
  end

  def handle_call({:edit_board, player_id, value}, _from, state) do
    {:reply, :ok, Board.update_board(state, player_id, value)}
  end

  def handle_call({:update_player_rank, player_id, rank_to_switch}, _from, state) do
    state
    |> Board.change_board_player_rank(player_id, rank_to_switch)
    |> case do
      {:ok, updated_board} -> {:reply, :ok, updated_board}
      _ -> {:reply, :error, state}
    end
  end

  defp find_or_create_player(player_attributes) do
    player_data = PlayerManager.find_player(:name, player_attributes.name)

    if player_data do
      player_data
    else
      PlayerManager.add_player(player_attributes)
    end
  end

  defp get_player_data(state) when length(state) > 0 do
    Enum.map(state, fn board_player ->
      player_data = PlayerManager.find_player(:id, Map.get(board_player, :player_id))
      Map.put(board_player, :player, player_data)
    end)
  end

  defp get_player_data(_) do
    []
  end

  defp server(pid) when is_pid(pid), do: pid

  defp server(name) do
    {:via, Registry, {MaddenDraft.BoardRegistry, name}}
  end
end
