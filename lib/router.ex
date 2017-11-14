defmodule Router do
  use Commanded.Commands.Router

  alias Commands.{StartGame, PlayMove}

  identify Game, by: :game_id
  dispatch [StartGame, PlayMove], to: Game
end
