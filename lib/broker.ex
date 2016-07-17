defmodule Broker do
  use GenServer

  def start_link(initial_val), do: GenServer.start_link(__MODULE__, initial_val, name: :broker)

  def receive(producer, val), do: GenServer.call(:broker, {:receive, producer, val})

  def handle_call({:receive, producer, val}, _from, bots) do
    Enum.each bots, &(Task.async(fn -> BotCaller.call({:receive, &1, producer, val}) end))
    {:reply, nil, bots}
  end
end


defmodule BotCaller do
  use GenServer

  def call(action) do
    require Logger
    Logger.debug("BrokerCaller: queued call: #{inspect action}")
    Task.async(fn ->
      :poolboy.transaction(:bot_caller_pool, fn(pid) ->
        GenServer.call(pid, action)
      end, :infinity)
    end)
  end

  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val, [])
  end

  def handle_call(action = {:receive, bot, producer, val}, _from, state) do
    require Logger
    Logger.debug("BrokerCaller: executing call: #{inspect action}")

    bot.receive(producer, val)
    {:reply, nil, state}
  end
end
