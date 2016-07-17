defmodule EchoBot do
  def receive(from, {chat, user, message}) do
    :timer.sleep(30)
    Producer.send_text(from, chat, %{text: message})
  end
end
