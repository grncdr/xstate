module XState
  class State
    def initialize(nodes, context, actions, history)
      @nodes = Array(nodes).uniq
      @actions = actions
      @context = context
      @history = history
    end

    attr_reader :actions, :context, :history

    def value
      @value ||= compute_value
    end

    private

    attr_reader :nodes

    def compute_value
      return nodes.first.value if nodes.size == 1
      nodes.each_with_object({}) do |node, hash|
        merge_value_hashes(hash, node.value)
      end
    end

    def merge_value_hashes(dest, src)
      raise "Cannot merge #{src.inspect} into value hash" unless src.is_a?(Hash)
      src.each do |key, value|
        if dest.key?(key)
          raise "Cannot merge #{src[key].inspect} with existing value #{dest[key].inspect} for key #{key.inspect}" unless dest[key].is_a?(Hash)
          merge_value_hashes(dest[key], src[key])
        else
          dest[key] = value
        end
      end
    end
  end
end