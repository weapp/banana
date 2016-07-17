defprotocol Producer do
  @fallback_to_any true

  def send_text(producer, chat, msg)
  def send_photo(producer, chat, msg)
end

# defprotocol ProducerText do
#   def send_text(producer, chat, msg)
# end
