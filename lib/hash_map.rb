# frozen_string_literal: true

require_relative './linked_list'
require_relative './node'

# class HashMap
class HashMap
  attr_accessor :capacity, :buckets

  def initialize
    @capacity = 16
    @load_factor = 0.75
    @buckets = Array.new(@capacity) { LinkedList.new }
    @size = 0
    @collitions = 0
  end

  def is_empty? # rubocop:disable Naming/PredicateName
    @size.zero?
  end

  def set(key, val)
    if @capacity * @load_factor < @size
      rehash
      set(key, val)
    else
      index = get_bucket_index(key)
      @collitions += 1 unless @buckets[index].is_empty?
      @buckets[index].set(key, val)
      @size += 1
    end
  end

  def remove(key)
    return nil if is_empty?

    @buckets[get_bucket_index(key)].delete(key)
    @collitions -= 1 if @buckets[get_bucket_index(key)].size <= 1
    @size -= 1
  end

  def clear
    initialize
  end

  def lenght
    @size
  end

  def entries
    @buckets.each do |bucket|
      bucket.each do |node|
        print "#{node.key} #{node.value}"
        puts
      end
    end
  end

  def get(key)
    return nil if is_empty?

    @buckets[get_bucket_index(key)].get(key)
  end

  def has?(key)
    return false if is_empty?

    @buckets[get_bucket_index(key)].has?(key)
  end

  private

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def get_bucket_index(key)
    hash(key) % capacity
  end

  def rehash # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @capacity *= 2
    @collitions = 0
    rehash_buckets = Array.new(@collitions) { LinkedList.new }
    rehash_insert = ->(index, current) { rehash_buckets[index].set(current.key, current.val) }
    @buckets.each do |bucket|
      current = bucket.head
      next unless current

      collitions += 1 unless rehash_buckets[get_bucket_index(current.key)].is_empty?
      rehash_insert.call(get_bucket_index(current.key), current)
      until current.next_node.nil?
        current = current.next_node
        collitions += 1 unless rehash_buckets[get_bucket_index(current.key)].is_empty?
        rehash_insert.call(get_bucket_index(current.key), current)
      end
    end
    @buckets = rehash_buckets
  end
end
