defmodule Producer.Shared do
  def send_photo(pid, chat, %{photo: url}) do
    Producer.send_text(pid, chat, %{text: "![img](#{url})"})
  end
end
