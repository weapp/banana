defmodule Banana do
  def start(type, args) do
    import Supervisor.Spec

    pool_options = [
      name: {:local, :bot_caller_pool},
      worker_module: BotCaller,
      size: 2,
      max_overflow: 0
    ]

    children = [
      :poolboy.child_spec(:bot_caller_pool, pool_options, nil),
      worker(DummyProducer, [{"manu", 0}, 750], id: :manu),
      worker(DummyProducer, [{"samu", 0}, 1500], id: :samu),
      worker(Broker, [[BananaBot, EchoBot]])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def color(data), do: data |> IO.ANSI.format(true) |> IO.iodata_to_binary()

  def yellow(str), do: color([:yellow, str])

  def cyan(str), do: color([:cyan, str])
end
