defmodule DummyProducer do
  defstruct [:pid]

  @default_period 1000

  # -- Daemon --
  use GenServer

  def start_link(initial_val, period \\ @default_period) do
    GenServer.start_link(__MODULE__, {initial_val, period})
  end

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
    if val < 10 do
      produce(
        %{chat: "chat"},
        %{user: name},
        "#{ticktock} #{val}"
      )
    end
    {name, val + 1}
  end

  def produce(chat, user, msg) do
    require Logger
    import Banana, only: [yellow: 1, cyan: 1]
    Logger.info(
      "DummyProducer: #{yellow "produce"}: #{cyan inspect {chat, user, msg}}"
    )
    Broker.receive(%__MODULE__{pid: self}, {chat, user, msg})
  end
end


defimpl Producer, for: DummyProducer do
  require Logger

  def send_text(producer, %{user: user}, msg) do
    send_text(producer, %{chat: "#{user} (private)"}, msg)
  end

  def send_text(_, %{chat: chat}, %{text: msg}) do
    require Logger
    import Banana, only: [green: 1, magenta: 1]
    Logger.info "send #{magenta inspect msg} in #{green chat}"
  end

  defdelegate send_photo(producer, chat, msg), to: Producer.Shared
end
