defmodule Read.Game do
  alias Events.{GameFinished}
  @type t :: {:ongoing, Game.t} | {:finished, Game.player}

  def apply(%GameFinished{winner: w}, {:ongoing, _}) do
    {:finished, w}
  end
  def apply(evt, {:ongoing, game}) do
    {:ongoing, Game.apply(game, evt)}
  end
  def apply(_, s), do: s
end
