defmodule Broker do
  use GenServer

  def start_link(initial_val), do: GenServer.start_link(__MODULE__, initial_val, name: :broker)

  def init(initial_val), do: {:ok, initial_val}

  def receive(producer, val), do: GenServer.call(:broker, {:receive, producer, val})

  def handle_call({:receive, producer, val}, _from, bots) do
    BotCaller.call(:do_work)

    Enum.each bots, &(Task.async(fn -> &1.receive(producer, val) end))
    {:reply, nil, bots}
  end
end


defmodule BotCaller do
  use GenServer

  # def call do
  #   {:ok, pid} = GenServer.start_link(BotCaller, nil)
  #   GenServer.call(pid, :do_work)
  # end

  def call(action) do
    Task.async(fn ->
      :poolboy.transaction(:my_pool, fn(pid) ->
        GenServer.call(pid, action)
      end)
    end)
  end

  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val, [])
  end

  def handle_call(:do_work, _from, state) do
    {d, h} = :calendar.local_time()
    IO.puts "> #{inspect h} >>>>> process #{inspect self} doing work "
    :timer.sleep 1000
    {:reply, "response", state}
  end
end
