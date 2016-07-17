defmodule BananaBot do
  def receive(from, {_chat, user, "tick " <> n}) do
    Producer.send_photo(from, user, %{photo: cat(n)})
  end

  def receive(_, _), do: nil

  def cat(n), do: "http://thecatapi.com/api/images/get?id=4#{n}"
end
