defmodule DummyProducer do
  defstruct [:pid]

  @default_period 1000

  # -- Daemon --
  use GenServer

  def start_link(initial_val, period \\ @default_period), do: GenServer.start_link(__MODULE__, {initial_val, period})

  def init({initial_val, period}) do
    Process.send_after(self, :tick, 0)
    {:ok, {period, initial_val}}
  end

  def handle_info(:tick, {period, state}) do
    Process.send_after(self, :tick, period)
    {:noreply, {period, tick(state)}}
  end
  # -- /Daemon --

  def tick({name, val}) do
    ticktock = if (rem(val, 2) == 0), do: "tick", else: "tock"
    produce(
      %{chat: "chat"},
      %{user: name},
      "#{ticktock} #{val}"
    )
    {name, val + 1}
  end

  def produce(chat, user, msg) do
    require Logger
    Logger.debug("DummyProducer: produce: #{inspect {chat, user, msg}}")
    Broker.receive(%__MODULE__{pid: self}, {chat, user, msg})
  end
end
