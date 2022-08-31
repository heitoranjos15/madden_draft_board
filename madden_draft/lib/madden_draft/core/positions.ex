defmodule MaddenDraft.Core.Position do
  @type t :: %__MODULE__{
          name: String.t(),
          skills: Map.t(),
          type: String.t(),
          side: String.t()
        }

  @enforce_keys [:name, :skills]
  defstruct name: "QuarterBack",
            skills: %{},
            type: "Balanced",
            side: ""

  @positions [
    QB: %{:name => "Quarterback"},
    RB: %{:name => "Running Back"},
    FB: %{:name => "Full Back"},
    TE: %{:name => "Tight End"},
    WR: %{:name => "Wide Receiver"},
    OG: %{:name => "Guard"},
    OT: %{:name => "Tackle"},
    C: %{:name => "Center"},
    DL: %{:name => "Defensive Line"},
    LB: %{:name => "Line Backer"},
    CB: %{:name => "Corner Back"},
    S: %{:name => "Safety"}
  ]

  def set_position(position, _, _)
      when position not in [:QB, :RB, :FB, :TE, :WR, :C, :CB, :S, :OG, :OT, :DL, :LB] do
    {:error, "invalid position"}
  end

  def set_position(position, skills, type)
      when position in [:QB, :RB, :FB, :TE, :WR, :C, :CB, :S] do
    Map.merge(@positions[:QB], %{:skills => skills, :type => type})
  end

  def set_position(position, skills, type, side) when position in [:OG, :OT, :DL, :LB] do
    Map.merge(@positions[position], %{:skills => skills, :type => type, :side => side})
  end
end
