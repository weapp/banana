defmodule Banana do
  def start(type, args) do
    import Supervisor.Spec

    pool_options = [
      name: {:local, :bot_caller_pool},
      worker_module: BotCaller,
      size: 2,
      max_overflow: 0,
      strategy: :fifo
    ]

    children = [
      :poolboy.child_spec(:bot_caller_pool, pool_options, nil),
      worker(DummyProducer, [{"manu", 0}, 750], id: :manu),
      worker(DummyProducer, [{"samu", 0}, 1500], id: :samu),
      worker(Broker, [[BananaBot, EchoBot]])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
