defmodule Projections.Game do
  use Commanded.Event.Handler, name: "game_projection"
  def init do
    with {:ok, _} <- Agent.start_link(fn -> %{} end, name: Projections.Game) do
      :ok
    end
  end

  def handle(%{game_id: id} = evt, _metadata) do
    Agent.update(Projections.Game, fn aggs ->
      aggs
      |> Map.update(id, {:ongoing, %Game{}}, &(Read.Game.apply(evt, &1)))
    end)
  end

  def get(id), do: Agent.get(Projections.Game, &(Map.get(&1, id)))
end
