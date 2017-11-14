defmodule Game do
  defstruct [
    game_id: nil,
    turn: :player_1,
    finished: false,
    board: [
      [nil,nil,nil],
      [nil,nil,nil],
      [nil,nil,nil]
    ]
  ]

  @type player :: :player_1 | :player_2

  @type slot :: player | nil
  @type board :: [[slot]]

  @type coord :: 0 | 1 | 2
  @type move :: { coord, coord }
  @type t :: %Game{game_id: any, turn: player, finished: boolean, board: board}

  alias Commands.{StartGame, PlayMove}
  alias Events.{GameStarted, MovePlayed, GameFinished}

  @spec apply(t, Events.t) :: t
  def apply(_, %GameStarted{game_id: gid}) do
    %Game{game_id: gid}
  end

  def apply(game, %MovePlayed{player: p, move: {x,y}}) do
    new_board = game.board
    |> List.update_at(x, &(&1 |> List.replace_at(y, p)))

    next_turn = if p == :player_1, do: :player_2, else: :player_1

    %Game{game | board: new_board, turn: next_turn}
  end

  def apply(game, %GameFinished{}) do
    %Game{game | finished: true}
  end

  @spec execute(t, Commands.t) :: nil | Events.t | [Events.t] | {:error, atom}
  def execute(%Game{game_id: nil}, %StartGame{game_id: id}) do
    %GameStarted{game_id: id}
  end
  def execute(_, %StartGame{}), do: {:error, :game_already_exists}

  def execute(%Game{} = game, %PlayMove{player: player, move: {x,y} = move}) do
    cond do
      game.finished ->
        {:error, :game_already_finished}
      game.turn != player ->
        {:error, :not_that_player_turn}
      x < 0 or x > 2 or y < 0 or y > 2 ->
        {:error, :invalid_move}
      not place_free(game.board, move) ->
        {:error, :position_already_marked}
      true ->
        %MovePlayed{game_id: game.game_id, player: player, move: move}
        |> add_finish_event_if_finished(game)
    end
  end

  @spec place_free(board, move) :: boolean
  def place_free(board, {x,y}) do
    p = board
    |> Enum.at(x, [])
    |> Enum.at(y, nil)

    p == nil
  end

  @spec add_finish_event_if_finished(Events.t, t) :: Events.t | [Events.t]
  def add_finish_event_if_finished(play_evt, game) do
    new_board = Game.apply(game, play_evt).board
    case winner(new_board) do
      nil ->
        play_evt
      w ->
        [play_evt, %GameFinished{game_id: game.game_id, winner: w}]
    end
  end

  @spec winner(board) :: player | :tie | nil
  def winner(board) do
    with nil <- row_winner(board),
         nil <- column_winner(board),
         nil <- diag_winner(board),
         nil <- check_tie(board),
      do: nil
  end

  @spec column_winner(board) :: player | nil
  def column_winner(board) do
    board
    |> transpose
    |> row_winner
  end

  @spec row_winner(board) :: player | :tie | nil
  def row_winner(board) do
    board |> Enum.find_value(&seq_winner/1)
  end

  @spec diag_winner(board) :: player | nil
  def diag_winner(board) do
    diag1 = board
    |> Enum.with_index
    |> Enum.map(fn {l, i} -> Enum.at(l,i) end)

    diag2 = board
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn {l, i} -> Enum.at(l,2 - i) end)

    with nil <- seq_winner(diag1),
         nil <- seq_winner(diag2),
      do: nil
  end

  @spec check_tie(board) :: :tie | nil
  def check_tie(board) do
    all_filled = board
    |> List.flatten
    |> Enum.all?(&(&1 != nil))

    if all_filled, do: :tie, else: nil
  end

  @spec seq_winner([player]) :: player | nil
  def seq_winner([p,p,p]), do: p
  def seq_winner(_), do: nil

  # Auxiliary functions

  @spec transpose([any]) :: [any]
  def transpose(l) do
    l
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end
end
