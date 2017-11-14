defmodule Read.Stats do
  defstruct [player_1: 0, player_2: 0, tie: 0]

  def update(stats, winner) do
    Map.update(stats, winner, 0, &(&1 + 1))
  end
end
