defmodule Banana do
  def start(type, args) do
    import Supervisor.Spec

    pool_options = [
      name: {:local, :my_pool},
      worker_module: BotCaller,
      size: 5,
      max_overflow: 10
    ]

    children = [
      :poolboy.child_spec(:my_pool, pool_options, []),
      worker(DummyProducer, [{"four", 4}, 1100], id: :four),
      worker(DummyProducer, [{"six-", 6}], id: :six),
      worker(Broker, [[BananaBot, EchoBot]])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
