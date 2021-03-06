defmodule Broker do
  use GenServer

  def start_link(initial_val), do: GenServer.start_link(__MODULE__, initial_val, name: :broker)

  def receive(producer, msg), do: GenServer.call(:broker, {:receive, producer, msg})

  def handle_call({:receive, producer, msg}, _from, bots) do
    Enum.each bots, &(BotCaller.call({:receive, &1, producer, msg}))
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
