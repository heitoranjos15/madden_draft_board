defmodule MaddenDraft.Core.Board do
  alias MaddenDraft.Core.Player

  require Logger

  @type t :: %__MODULE__{
          player_id: Integer.t(),
          rank: Integer.t(),
          status: Atom.t(),
          player: Player.t(),
          drafted_by: String.t()
        }
  @enforce_keys [:player_id, :rank, :status]

  defstruct player_id: 0,
            rank: 0,
            status: :available,
            player: %Player{
              id: "",
              name: "",
              college: "",
              age: "",
              round_expected: "",
              position: ""
            },
            drafted_by: ""

  def new(attributes) do
    try do
      {:ok, struct!(__MODULE__, attributes)}
    rescue
      _ -> {:error, "invalid player rank"}
    end
  end

  def change_board_player_rank(board, player_rank, rank_to_switch) do
    player = find_board_player(board, :player_id, player_rank)
    player_to_switch = find_board_player(board, :player_id, rank_to_switch)

    if !is_nil(player) and !is_nil(player_to_switch) do
      try do
        board_updated = switch_board_players_ranks(board, player_rank, rank_to_switch)
        {:ok, board_updated}
      rescue
        error ->
          Logger.error("error", error.message)
          {:error, error}
      end
    end
  end

  defp switch_board_players_ranks(board, player_rank, rank_to_switch) do
    player1 = board |> Enum.at(player_rank) |> Map.put(:rank, rank_to_switch)
    player2 = board |> Enum.at(rank_to_switch) |> Map.put(:rank, player_rank)

    board
    |> List.replace_at(rank_to_switch, player1)
    |> List.replace_at(player_rank, player2)
    |> sort_board_by
  end

  def filter_board(board, by, value),
    do: Enum.filter(board, &(Map.get(&1, by) == value)) |> sort_board_by

  def filter_board_by_players(board, by, value),
    do: Enum.filter(board, &(Map.get(&1.player, by) == value)) |> sort_board_by

  def update_board(state, player_id, value) do
    board_idx = Enum.find_index(state, &(&1.player_id == player_id))
    board = Enum.at(state, board_idx)
    player_edited = Map.merge(board, value)

    List.replace_at(state, board_idx, player_edited)
  end

  def sort_board_by(board) do
    Enum.sort(board, &(&1.rank < &2.rank))
  end

  def sort_board_by(board, :age) do
    Enum.sort(board, &(&1.player.age < &2.player.age))
  end

  defp find_board_player(board, by, value) do
    Enum.find(board, &(Map.get(&1, by) == value))
  end
end
