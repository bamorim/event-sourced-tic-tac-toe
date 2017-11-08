defmodule ReadDb do
  use Commanded.Event.Handler, name: "read_db"
  def init do
    with {:ok, _} <- Agent.start_link(fn -> %{} end, name: ReadDb) do
      :ok
    end
  end

  def handle(%{game_id: id} = evt, _metadata) do
    Agent.update(ReadDb, fn aggs ->
      aggs
      |> Map.update(id, {:ongoing, %Game{}}, &(ReadGame.apply(&1, evt)))
    end)
  end

  def get(id), do: Agent.get(ReadDb, &(Map.get(&1, id)))
end
