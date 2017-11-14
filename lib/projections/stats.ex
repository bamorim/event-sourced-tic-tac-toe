defmodule Projections.Stats do
  use Commanded.Event.Handler, name: "stats_projection"
  alias Events.GameFinished
  alias Read.Stats

  def init do
    with {:ok, _} <- Agent.start_link(fn -> %Stats{} end, name: Projections.Stats) do
      :ok
    end
  end

  def handle(%GameFinished{winner: winner}, _metadata) do
    Agent.update(Projections.Stats, &(Stats.update(&1, winner)))
  end

  def stats do
    Agent.get(Projections.Stats, &(&1))
  end
end
