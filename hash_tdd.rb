require 'test-unit'
class OutOfMemoryBoundary < StandardError
end

class HashKeyOutOfBound < StandardError
end

class FakeHash
  def initialize(size)
    @body = Array.new(size)
  end

  #when there is a hash collision, a new array pair is pushed to the end. getter and delete operations are derived from such logic when collision happens.
  def set_value(key, value)
    key = key.to_s unless key.kind_of? String
    index = convert_to_index(key)
    return @body[index] = [key, value] unless @body[index]

    if @body[index][0] == key
      @body[index][1] = value
    elsif get_collision_pair_index(key, index)
      @body[index][get_collision_pair_index(key, index)][1] = value
    else
      @body[index].push([key, value])
    end
  end

  def get_value(key)
    key = key.to_s unless key.kind_of? String
    index = convert_to_index(key)
    return nil unless @body[index]
    @body[index][0] == key ? @body[index][1] : get_collision_value(key, index)
  end

  def delete_pair(key)
    key = key.to_s unless key.kind_of? String
    index = convert_to_index(key)
    return nil unless @body[index]
    @body[index][0] == key ? @body[index] = nil : @body[index].slice!(get_collision_pair_index(key, index))
  end

private
  def convert_to_index(key)
    key.each_char { |char| check_key_ascii(char) }
    index = key.split('').inject(0){|s, v| s + v.ord}
    raise OutOfMemoryBoundary if index > @body.size
    index
  end

  def check_key_ascii(char)
    index = char.ord
    raise HashKeyOutOfBound if index < 33 || index > 125
  end

  def get_collision_value(key, index)
    @body[index][2..-1].each do |pair|
      return pair[1] if pair[0] == key
    end
    nil
  end

  def get_collision_pair_index(key, index)
    @body[index].each_with_index do |pair, index|
      return index if pair[0] == key
    end
    nil
  end
end


class HashTest < Test::Unit::TestCase
  def setup
    @hash = FakeHash.new(1000)
    @key = 'key'
  end

  def test_initialize
    assert_equal @hash.class, FakeHash
  end

  def test_setting_key_value_pair_within_memory_boundary
    assert_equal @hash.set_value(@key, 'test_value'), [@key, 'test_value']
  end

  def test_setting_outside_of_memory_boundary
    key = 'aacbbaaadddff'
    assert_raise(OutOfMemoryBoundary) { @hash.set_value(key, 'test_value') }
  end

  def test_getting_outside_of_memory_boundary
    key = 'aacbbaaadddff'
    assert_raise(OutOfMemoryBoundary) { @hash.get_value(key) }
  end

  def test_getting_value_given_key
    @hash.set_value(@key, 'test_value')
    assert_equal 'test_value', @hash.get_value(@key)
  end

  def test_update_value
    @hash.set_value(@key, 'test_value')
    @hash.set_value(@key, 'new_value')
    assert_equal 'new_value', @hash.get_value(@key)
  end

  def test_get_value_at_non_existing_pair
    assert_nil @hash.get_value(@key)
  end

  def test_key_out_of_bound
    key = ' '
    key2 = '~'
    assert_raise(HashKeyOutOfBound) { @hash.set_value(key, 'test_value') }
    assert_raise(HashKeyOutOfBound) { @hash.set_value(key2, 'test_value') }
  end

  def test_key_not_string
    key = 12
    @hash.set_value(key, 'test_value')
    assert_equal 'test_value', @hash.get_value('12')
  end

  def test_hash_collisions
    key1 = 'bc'
    key2 = 'ad'
    @hash.set_value(key1, 'bc_value')
    @hash.set_value(key2, 'ad_value')
    assert_equal 'bc_value', @hash.get_value(key1)
  end

  def test_multiple_hash_collisions
    key1 = 'ag'; key2 = 'bf'; key3 = 'ce'
    @hash.set_value(key1, 'ag_value')
    @hash.set_value(key2, 'bf_value')
    @hash.set_value(key3, 'ce_value')
    assert_equal 'ag_value', @hash.get_value(key1)
    assert_equal 'bf_value', @hash.get_value(key2)
    assert_equal 'ce_value', @hash.get_value(key3)
  end

  def test_delete_pair_without_collision
    @hash.set_value(@key, 'test_value')
    @hash.delete_pair(@key)
    assert_nil @hash.get_value(@key)
  end

  def test_delete_pair_with_collision
    key1 = 'ag'; key2 = 'bf'; key3 = 'ce'
    @hash.set_value(key1, 'ag_value')
    @hash.set_value(key2, 'bf_value')
    @hash.set_value(key3, 'ce_value')
    @hash.delete_pair(key3)
    @hash.delete_pair(key2)
    assert_nil @hash.get_value(key3)
    assert_nil @hash.get_value(key2)
  end

  def test_update_collision_pair
    h = FakeHash.new(200)
    key1 = 'ag'; key2 = 'bf'; key3 = 'ce'
    h.set_value(key1, 'value1')
    h.set_value(key2, 'value2')
    h.set_value(key2, 'value3')
    assert_equal 'value3', h.get_value(key2)
    h.set_value(key3, 'ce_value')
    h.set_value(key3, 'ce_value2')
    assert_equal 'value3', h.get_value(key2)
    assert_equal 'ce_value2', h.get_value(key3)
  end

end



