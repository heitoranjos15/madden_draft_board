defmodule MaddenDraft.Core.Player do
  @type t :: %__MODULE__{
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
    :name,
    :college,
    :age,
    :round_expected,
    :position
  ]
  defstruct name: "",
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

  def new(attributes) when not is_map(attributes) do
    new(%{
      name: Enum.at(attributes, 0),
      college: Enum.at(attributes, 1),
      age: Enum.at(attributes, 2),
      round_expected: Enum.at(attributes, 3),
      position: Enum.at(attributes, 4)
    })
  end

  def new(attributes) do
    struct!(__MODULE__, attributes)
  end
end
