defmodule Producer.Shared do
  def send_photo(pid, chat, url) do
    IO.inspect "pid"
    IO.inspect pid
    IO.inspect "pid"
    Producer.send_text(pid, chat, %{text: "photo: #{inspect url}"})
  end
end


defimpl Producer, for: Any do
  defdelegate send_photo(producer, chat, msg), to: Producer.Shared

  def send_text(pid, chat, url) do
    Producer.send_text(pid, chat, url)
  end
end


defimpl Producer, for: DummyProducer do
  def send_text(_, chat = %{user: _}, %{text: msg}) do
    IO.puts "sending `#{msg}` to user in private: `#{inspect chat}`"
  end

  def send_text(_, chat = %{chat: _}, %{text: msg}) do
    IO.puts "sending `#{msg}` to chat: `#{inspect chat}`"
  end

  defdelegate send_photo(producer, chat, msg), to: Producer.Shared
end

