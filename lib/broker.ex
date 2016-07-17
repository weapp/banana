defmodule Broker do
  use GenServer

  def start_link(initial_val), do: GenServer.start_link(__MODULE__, initial_val, name: :broker)

  def init(initial_val), do: {:ok, initial_val}

  def receive(producer, val), do: GenServer.call(:broker, {:receive, producer, val})

  def handle_call({:receive, producet, val}, _from, bots) do
    Enum.each bots, &(Task.async(fn -> &1.receive(producet, val) end))
    {:reply, nil, bots}
  end
end
