defmodule Events do
  defmodule GameStarted, do: defstruct [game_id: nil]
  @type game_started :: %GameStarted{game_id: any}
  defmodule MovePlayed, do: defstruct [game_id: nil, player: nil, move: nil]
  @type move_played :: %MovePlayed{game_id: any, player: Game.player, move: Game.move}
  defmodule GameFinished, do: defstruct [game_id: nil, winner: nil]
  @type game_finished :: %GameFinished{game_id: any, winner: Game.player | :tie}
  @type t :: game_started | move_played | game_finished
end
