defmodule MaddenDraft.Boundary.BoardManager do
  use GenServer

  require Logger

  alias MaddenDraft.Core.Board
  alias MaddenDraft.Boundary.PlayerManager

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: server(name))
  end

  def lazy_player(name) do
    GenServer.cast(server(name), {:lazy_player})
  end

  def add_player_to_board(name, player) do
    GenServer.call(server(name), {:add_player_to_board, player})
  end

  def show(name) do
    GenServer.call(server(name), {:show})
  end

  def player_rank(name, player_id, choose) do
    GenServer.call(server(name), {:player_rank, player_id, choose})
  end

  def show_players_filter(name, filter, value) do
    GenServer.call(server(name), {:show_players_filter, filter, value})
  end

  def player_drafted(name, player_id, drafted_by) do
    GenServer.call(server(name), {:player_drafted, player_id, drafted_by})
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
    player_data = find_or_create_player(player)

    # player_data
    # |> inspect()
    # |> Logger.debug()

    attributes = %{player_id: player_data.id, rank: length(state), status: :available}

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

  def handle_call({:player_rank, player_id, choose}, _from, state) do
    player_id
    |> Board.change_board_player_rank(choose, state)
    |> case do
      {:ok, updated_board} -> {:reply, :ok, updated_board}
      _ -> {:reply, :error, state}
    end
  end

  def handle_call({:show_players_filter, filter, value}, _from, state) do
    players =
      get_player_data(state)
      |> Board.search_board_player_by(filter, value)

    {:reply, players, state}
  end

  def handle_call({:player_drafted, player_id, drafted_by}, _from, state) do
    updated_board =
      state
      |> Enum.find_index(fn player -> player.player_id == player_id end)
      |> (&List.replace_at(
            state,
            &1,
            Map.merge(Enum.at(state, &1), %{drafted_by: drafted_by, status: :drafted})
          )).()

    {:reply, :ok, updated_board}
  end

  defp find_or_create_player(player_attributes) do
    player_data = PlayerManager.find_player(:name, player_attributes.name)

    if player_data do
      player_data
    else
      PlayerManager.add_player(player_attributes)
    end
  end

  defp get_player_data(board) do
    set_player_data_fun = fn board_player ->
      player_data = PlayerManager.find_player(:id, board_player.player_id)
      Map.put(board_player, :player, player_data)
    end

    Enum.map(board, set_player_data_fun)
  end

  defp server(pid) when is_pid(pid), do: pid

  defp server(name) do
    {:via, Registry, {MaddenDraft.BoardRegistry, name}}
  end
end
