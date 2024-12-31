# frozen_string_literal: true

# class Node
class Node
  attr_accessor :key, :value, :next_node, :prev

  def initialize(key, value, following = nil, prev = nil)
    @key = key
    @value = value
    @next_node = following
    @prev = prev
  end
end
