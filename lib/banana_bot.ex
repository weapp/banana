defmodule BananaBot do
  def receive(from, {_chat, user, "tick " <> message}) do
    Producer.send_photo(from, user, %{photo: "message.jpg"})
  end

  def receive(_, _), do: nil
end
