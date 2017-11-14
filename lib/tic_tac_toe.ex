defmodule TicTacToe do
  alias Commands.{StartGame, PlayMove}
  def start do
    {:ok, _pid} = Commanded.EventStore.Adapters.InMemory.start_link()
    {:ok, _handler} = Projections.Game.start_link()
    {:ok, _handler} = Projections.Stats.start_link()
    :ok
  end

  def start_game(id) do
    Router.dispatch(%StartGame{game_id: id})
  end

  def play(id, player, move) do
    Router.dispatch(%PlayMove{game_id: id, player: player, move: move})
  end
end
