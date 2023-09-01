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
    player = find_board_player_by(board, :player_id, player_rank)
    player_to_switch = find_board_player_by(board, :player_id, rank_to_switch)

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
    board
    |> Enum.map(fn player_board ->
      cond do
        player_board.rank == player_rank ->
          Map.put(player_board, :rank, rank_to_switch)

        player_board.rank == rank_to_switch ->
          Map.put(player_board, :rank, player_rank)

        true ->
          player_board
      end
    end)
    |> sort_board_by
  end

  defp find_board_player_by(board, :player_id, id) do
    Enum.find(board, &(&1.player_id == id))
  end

  def sort_board_by(board) do
    Enum.sort(board, &(&1.rank < &2.rank))
  end

  def sort_board_by(board, :age) do
    Enum.sort(board, &(&1.player.age < &2.player.age))
  end

  def search_board_player_by(board, :rank, value),
    do: Enum.filter(board, &(&1.rank == value)) |> sort_board_by

  def search_board_player_by(board, :status, value),
    do: Enum.filter(board, &(&1.status == value)) |> sort_board_by

  def search_board_player_by(board, :drafted_by, value),
    do: Enum.filter(board, &(&1.drafted_by == value)) |> sort_board_by

  def search_board_player_by(board, filter, value),
    do: Enum.filter(board, &(Map.get(&1.player, filter) == value)) |> sort_board_by
end
