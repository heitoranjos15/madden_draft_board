defmodule MaddenDraft.Boundary.PlayerManager do
  use GenServer
  alias MaddenDraft.Core.Player

  def start_link(opts \\ []) do
    state = opts[:players] || []
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def add_player(server \\ __MODULE__, player_attributes) do
    GenServer.call(server, {:add_player, player_attributes})
  end

  def get_players(server \\ __MODULE__) do
    GenServer.call(server, {:get_players})
  end

  def get_player(server \\ __MODULE__, player_name) do
    GenServer.call(server, {:get_player, player_name})
  end

  def find_player(server \\ __MODULE__, by, value) do
    GenServer.call(server, {:find_player, by, value})
  end

  def update_player(server \\ __MODULE__, id, attribute, value) do
    GenServer.call(server, {:update_player, id, attribute, value})
  end

  def init(state) do
    {:ok, state}
  end

  def reorder_players(state) do
    Enum.sort(state,  &(&1.round_expected < &2.round_expected))
  end

  def handle_call(message, from, state)

  def handle_call({:add_player, player_attributes}, _from, state) do
    player_result = player_attributes
    |> String.split("-")
    |> Player.new()

    case player_result do
      {:ok, %Player{} = player } -> {:reply, :ok, [player | state]}
      error -> {:reply, error, state }
    end

  end

  def handle_call({:get_player, player_id}, _from, state) do
    player = Enum.at(state, player_id)
    {:reply, player, state}
  end

  def handle_call({:get_players}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:find_player, by, value}, _from, state) do
    player = Enum.filter(state, &(Map.get(&1, by) == value))
    {:reply, player, state}
  end

  def handle_call({:update_player, id, attribute, value}, _from, state) do
    player =
      Enum.at(state, id)
      |> Player.update(attribute, value)

    case player  do
      {:ok, player } -> {:reply, player, List.replace_at(state, id, player) }
      error -> {:reply, error, state }
    end
  end
end
