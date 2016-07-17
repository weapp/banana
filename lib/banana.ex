defmodule Banana do
  def start(type, args) do
    # import Supervisor.Spec

    # children = [
    #   worker(Task, [KVServer, :accept, [4040]])
    # ]

    # opts = [strategy: :one_for_one, name: KVServer.Supervisor]
    # Supervisor.start_link(children, opts)

    IO.puts "type:"
    IO.inspect type
    IO.puts "args:"
    IO.inspect args

    # receiver = spawn_link(Banana, :broker, [])
    # spawn_link(Banana, :genereator, [receiver])


    # Rumbl.Counter.start_link(5)

    # {:ok, self}

    import Supervisor.Spec

    children = [
      # worker(Rumbl.Counter, [[4], [name: MyCounter]])
      worker(DummyProducer, [{"four", 4}, 1100], id: :four),
      worker(DummyProducer, [{"six-", 6}], id: :six),
      worker(Broker, [[BananaBot, EchoBot]])
    ]

    # {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
    # {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_all)
    # {:ok, pid} =
    Supervisor.start_link(children, strategy: :rest_for_one)
  end

  def genereator(parent) do
    send parent, {:msg, :lalala3}
    :timer.sleep(:timer.seconds(1))
    genereator(parent)
  end

  def broker do
    receive do
      {:msg, msg} -> IO.puts msg
      other -> other
    end
    broker
  end
end
