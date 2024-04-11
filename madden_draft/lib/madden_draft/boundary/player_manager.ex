defmodule MaddenDraft.Boundary.PlayerManager do
  use GenServer
  require Logger

  alias Ecto.Adapter.Schema
  alias MaddenDraft.Database.Schema.Player, as: Schema
  alias MaddenDraft.Core.Player
  alias MaddenDraft.Database.Repo

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

  def find_player(server \\ __MODULE__, by, value) do
    GenServer.call(server, {:find_player, by, value})
  end

  def update_player(server \\ __MODULE__, id, attribute, value) do
    GenServer.call(server, {:update_player, id, attribute, value})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(message, from, state)

  def handle_call({:add_player, player_attributes}, _from, state) do
    player_attributes
    |> (&Player.new(length(state), &1)).()
    |> case do
      {:ok, %Player{} = player} ->
        # Repo.insert!(player_to_schema(player))
        {:reply, player, [player | state]}

      error ->
        {:reply, error, state}
    end
  end

  def handle_call({:get_players}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:find_player, by, value}, _from, state) do
    player = Enum.find(state, &(Map.get(&1, by) == value))
    {:reply, player, state}
  end

  def handle_call({:update_player, id, attribute, value}, _from, state) do
    player =
      Enum.at(state, id)
      |> Player.update(attribute, value)

    case player do
      {:ok, player} -> {:reply, player, List.replace_at(state, id, player)}
      error -> {:reply, error, state}
    end
  end


  defp player_to_schema(player) do
    %Schema{
      name: player.name,
      age: player.age,
      height: player.height,
      skills: player.skills,
      weight: player.weight,
      college: player.college
    }
  end
end
