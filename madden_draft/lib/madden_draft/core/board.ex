defmodule MaddenDraft.Core.Board do
  alias MaddenDraft.Core.Player

  require Logger

  @type t :: %__MODULE__{
          player_id: Integer.t(),
          rank: Integer.t(),
          status: Atom.t(),
          player: Player.t(),
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
    }

  def new(attributes) do
    try do
      {:ok, struct!(__MODULE__, attributes) }
    rescue
      _ -> {:error, "invalid player rank" }
    end
  end

  def change_board_player_rank(player, choose, board) do
    player_board = find_board_player_by(board, :player_id, player)

    try do
      board_updated = make_board_switches(board, player_board, choose) 
      {:ok, board_updated}
    rescue
      error -> {:error, error.message }
    end
  end

  defp make_board_switches(board, player_board, choose) do
    player_choose_rank = player_board.rank

    valid = validate_choose(choose, length(board), player_choose_rank)
    if not valid do
      raise ArgumentError, "invalid player choose"
    end

    player_switch_rank = get_player_switch_rank(choose, player_choose_rank)

    switch_board_player_ranks(board, player_choose_rank, player_switch_rank)
  end

  defp validate_choose(choose, board_limit, player_rank) do
    choose_up = choose == :up
    choose_down = choose == :down
    top_ranked = player_rank == 0
    last_ranked = player_rank == board_limit

    cond do
      top_ranked and choose_up -> false
      last_ranked and choose_down -> false
      true -> true
    end
  end

  defp switch_board_player_ranks(board, player_choose_rank, player_switch_rank) do
    board
    |> Enum.map(fn player_board ->
      cond do
        player_board.rank == player_choose_rank -> Map.put(player_board, :rank, player_switch_rank)
        player_board.rank == player_switch_rank -> Map.put(player_board, :rank, player_choose_rank)
        true -> player_board
      end
    end)
    |> sort_board_by
  end

  defp get_player_switch_rank(choose, player_rank) do
    rank = case choose do
      :up -> player_rank - 1
      :down -> player_rank + 1
    end
    if rank < 0 do
      raise ArgumentError, "invalid player rank"
    end
    rank
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

end
