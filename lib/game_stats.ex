defmodule GameStats do
  use Commanded.Event.Handler, name: "game_stats"
  alias Game.Events.GameFinished
  def init do
    with {:ok, _} <- Agent.start_link(fn -> %{won_p1: 0, won_p2: 0} end, name: GameStats) do
      :ok
    end
  end

  def handle(%GameFinished{winner: :player_1}) do
    Agent.update(GameStats, &(%{&1 | won_p1: &1.won_p1 + 1}))
  end
  def handle(%GameFinished{winner: :player_2}) do
    Agent.update(GameStats, &(%{&1 | won_p1: &1.won_p2 + 1}))
  end

  def stats do
    Agent.get(GameStats, &(&1))
  end
end
