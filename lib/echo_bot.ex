defmodule EchoBot do
  def receive(from, {chat, user, message}) do
    Producer.send_text(from, chat, %{text: message})
    Producer.send_photo(from, user, %{photo: "message.jpg"})
  end
end
