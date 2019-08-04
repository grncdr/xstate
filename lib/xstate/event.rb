module XState
  Event = Struct.new(:type, :params) do
    def self.from_unknown(event)
      unless event.is_a? Event
        if event.is_a?(String) || event.is_a?(Symbol)
          Event.new(event.to_s, {})
        elsif event.is_a?(Hash)
          Event.new((event.delete(:type) || event.delete('type')).to_s, event)
        else
          raise "Invalid event, must be a string, symbol, or a hash with a :type key #{event.inspect}"
        end
      end
    end
  end
end