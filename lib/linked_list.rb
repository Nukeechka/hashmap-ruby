# frozen_string_literal: true

require_relative './node'

# class LinkedList
class LinkedList
  include Enumerable

  attr_accessor :head

  def initialize
    @head = nil
  end

  def is_empty? # rubocop:disable Naming/PredicateName
    @head.nil?
  end

  def include?(key)
    return false if is_empty?
    return true if @head.key == key

    current = @head
    until current.next_node.nil?
      current = current.next_node
      return true if current.key == key

      false
    end
  end

  def set(key, val)
    return @head = Node.new(key, val) if is_empty?

    current = last_node
    current.next_node = Node.new(key, val, nil, current)
  end

  def insert_first(key, val)
    new_node = Node.new(key, val, @head)
    new_node.next_node.prev = new_node
    @head = new_node
  end

  def delete(key)
    return if is_empty? || !include?(key)

    remove_head if @head.key == key
    last_node do |current|
      delete_key(current) if current.key == key
    end
  end

  def delete_first
    remove_head
  end

  def delete_last
    last = last_node
    delete_key(last)
  end

  def get(key)
    return nil if is_empty? || !include?(key)
    return @head.val if @head.key == key

    current = @head
    until current.next_node.nil?
      current = current.next_node
      return current.val if current.key == key
    end
  end

  def last
    last_node.val
  end

  def first
    is_empty? ? nil : @head.val
  end

  def size
    return 0 if is_empty? current = @head

    count = 0
    until current.next_node.nil?
      current = current.next_node
      count += 1
      count
    end
  end

  def each
    return if is_empty?

    yield(head) if defined?(yield)
    current = @head
    until current.next_node.nil?
      current = current.next_node
      yield(current) if defined?(yield)
    end
  end

  private

  def remove_head(_key)
    val = @head.val
    @head = @head.next_node
    @head.prev = nil if @head
    val
  end

  def last_node
    return if is_empty?

    current = @head
    until current.next_node.nil?
      current = current.next_node
      yield(current) if defined?(yield)

    end
    current
  end

  def delete_key(current)
    prev = current.prev
    prev.next_node = current.next_node
    current.next_node&.prev = prev
    current.prev = nil
    current.next_node = nil
  end
end
