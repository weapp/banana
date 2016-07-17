defmodule EchoBot do
  def receive(from, {chat, user, message}) do
    Producer.send_text(from, chat, %{text: message})
  end
end
