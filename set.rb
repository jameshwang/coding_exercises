class Set
  def initialize(values=[])
    @values = values
  end

  def size
    @values.length
  end

  def add(value)
    @values.push value unless include?(value)
  end

  def include?(value)
    @values.include? value
  end

  def remove(value)
    @values.delete(value)
  end

end


class FakeTestUnit
  def assert(condition)
    output = condition ? '.' : 'f'
    puts output
  end

  def assert_equal(expected, actual)
    output = expected == actual ? '.' : 'f'
    puts output
  end
end


class SetTest < FakeTestUnit
  def initialize
    @set = Set.new([1,2])
  end

  def test_creating_with_initial_value
    assert_equal 2, @set.size
  end

  def test_creating_without_initial_value
    set = Set.new
    assert_equal 0, set.size
  end

  def test_size
    set = Set.new
    assert_equal 0, set.size
    set.add(4)
    assert_equal 1, set.size
  end

  def test_add_item_to_set
    set = Set.new
    set.add(5)
    assert_equal 1, set.size
    set.add(5)
    assert_equal 1, set.size
    set.add(6)
    assert_equal 2, set.size
  end

  def test_membership
    set = Set.new
    assert_equal false, set.include?(5)
    set.add 5
    assert set.include?(5)
  end

  def test_remove_item
    set = Set.new([5,2])
    set.remove(5)
    assert_equal 1, set.size
  end
end

set_test = SetTest.new
SetTest.instance_methods(false).select { |m| m =~ /^test_/ }.each {|m| set_test.send(m) }



