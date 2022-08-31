defmodule MaddenDraft.Boundary.PlayerManager do
  use GenServer
  alias MaddenDraft.Core.Player

  def start_link(opts \\ []) do
    players = opts[:players] || []
    GenServer.start_link(__MODULE__, players, name: __MODULE__)
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

  def init(player_list) do
    players = player_list
    {:ok, players}
  end

  def handle_call(message, from, players)

  def handle_call({:add_player, player_attributes}, _from, players) do
    attributes = String.split(player_attributes, "-")

    new_player = Player.new(attributes)

    players = Enum.sort([new_player | players], &(&1.round_expected < &2.round_expected))

    {:reply, :ok, players}
  end

  def handle_call({:get_player, player_id}, _from, players) do
    player = Enum.at(players, player_id)
    {:reply, player, players}
  end

  def handle_call({:get_players}, _from, players) do
    {:reply, players, players}
  end

  def handle_call({:find_player, by, value}, _from, players) do
    player = Enum.filter(players, &(Map.get(&1, by) == value))
    {:reply, player, players}
  end

  def handle_call({:update_player, id, attribute, value}, _from, players) do
    player =
      Enum.at(players, id)
      |> (&Map.put(&1, attribute, value)).()

    {:reply, player, players}
  end
end
