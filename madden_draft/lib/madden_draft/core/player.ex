defmodule MaddenDraft.Core.Player do
  alias MaddenDraft.Core.CombineStats

  @type t :: %__MODULE__{
          id: Integer.t(),
          name: String.t(),
          college: String.t(),
          age: Integer.t(),
          round_expected: Integer.t(),
          position: String.t(),
          height: String.t(),
          weight: String.t(),
          skills: Map.t(),
          type: String.t(),
          side: String.t(),
          combine: Map.t()
        }

  @enforce_keys [
    :id,
    :name,
    :college,
    :age,
    :round_expected,
    :position
  ]

  defstruct name: "",
    id: "",
    college: "",
    age: 0,
    round_expected: 1,
    position: "",
    height: "",
    weight: "",
    skills: %{},
    type: "",
    side: "",
    combine: %{}

  def new(id, attributes) when not is_map(attributes) do
    new(%{
      id: id,
      name: Enum.at(attributes, 0),
      college: Enum.at(attributes, 1),
      age: Enum.at(attributes, 2),
      round_expected: Enum.at(attributes, 3),
      position: Enum.at(attributes, 4)
    })
  end

  def new(attributes) do
    try do
      {:ok, struct!(__MODULE__, attributes)}
    rescue
       _ -> 
        {:error, "invalid player attributes" }
    end
  end

  def update(player, _, _) when is_nil(player) do
    {:error, "player not found" }
  end

  def update(player, attribute, value) do
    case attribute do
      :combine -> add_combine_stats(player, value)
      _ -> {:ok, Map.put(player, attribute, value)}
    end
  end

  def add_combine_stats(player, value) do
    value
    |> String.split("-")
    |> Enum.map(&String.to_float/1)
    |> CombineStats.new
    |> case do
      {:ok, combine_result } -> Map.put(player, :combine, combine_result)
      error -> error
    end
  end
end
