class Hash
  attr_accessor :memory
  def initialize(args)
    @memory = Array.new(args[:mem_size])
  end

  def self.convert_key_to_index(key)
    key.split('').map {|k| k.ord}.inject(0){|s, v| s+v}
  end

  def add_pair(key, value)
    index = Hash.convert_key_to_index(key)
    if self.memory.length > index
      self.memory[index] = value
    else
      raise 'Memory overloaddddd'
    end
  end

  def get_value(key)
    index = Hash.convert_key_to_index(key)
    self.memory[index] ? self.memory[index] : (raise "That key does not exist!")
  end

  def set_value(key, new_value)
    index = Hash.convert_key_to_index(key)
    self.memory[index] ? self.memory[index] = new_value : (raise 'That key does not exist')
  end

end

hash = Hash.new(:mem_size => 1500)

hash.add_pair('key', 'value')
hash.set_value('key', 'xyz')
hash.add_pair('sadfdsasdfsafs', 'sdf')
p hash.get_value('sadfdsasdfsafs')