defmodule Commands do
  defmodule StartGame, do: defstruct [game_id: nil]
  @type start_game :: %StartGame{game_id: any}
  defmodule PlayMove, do: defstruct [game_id: nil, player: nil, move: nil]
  @type play_move :: %PlayMove{game_id: any, player: Game.player, move: Game.move}
  @type t :: start_game | play_move
end
