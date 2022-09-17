defmodule MaddenDraft.Core.CombineStats do
  @type t :: %__MODULE__{
          fourty_yard_dash: Integer.t(),
          vert_jump: Integer.t(),
          broad_jump: Integer.t(),
          three_cone: Integer.t(),
          twenty_yard_shuttle: Integer.t(),
          bench_press: Integer.t(),
        }

  @enforce_keys [
    :fourty_yard_dash,
    :vert_jump,
    :broad_jump,
    :three_cone,
    :twenty_yard_shuttle,
    :bench_press,
  ]

  defstruct fourty_yard_dash: 0,
            vert_jump: 0,
            broad_jump: 0,
            three_cone: 0,
            twenty_yard_shuttle: 0,
            bench_press: 0

  def new(stats) when is_list(stats) do
    new(%{
      fourty_yard_dash: Enum.at(stats, 0),
      vert_jump: Enum.at(stats, 1),
      broad_jump: Enum.at(stats, 2),
      three_cone: Enum.at(stats, 3),
      twenty_yard_shuttle: Enum.at(stats, 4),
      bench_press: Enum.at(stats, 5)
    })
  end

  def new(attributes) do
    try do
      {:ok, struct!(__MODULE__, attributes)}
    rescue
      _ -> {:error, "invalid combine attributes" }
    end
  end
end
