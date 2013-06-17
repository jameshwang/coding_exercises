class Car
  attr_reader :ignited, :direction
  def initialize(brand, model, args={})
    @brand = brand
    @model = model
    @color = args[:color]
    @mpg = args[:mpg]
    @ignited = false
    @direction = nil
  end

  def start
    @ignited = true
  end

  def stop
    @ignited = false
  end

  def forward
    move { @direction = :forward }
  end

  def backward
    move { @direction = :backward }
  end

  def ignited?
    self.ignited
  end

  private

  def move
    if self.ignited
      yield
    else
      raise 'Car is not turned on!'
    end
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


class CarTest < FakeTestUnit
  def test_starting_the_car
    car = Car.new('honda', 'x1')
    car.start

    assert car.ignited?
  end

  def test_car_direction
    car = Car.new('honda', 'x1')
    car.start
    car.forward

    assert_equal :forward, car.direction
  end
end

car_test = CarTest.new
CarTest.instance_methods(false).select { |m| m =~ /^test_/ }.each {|m| car_test.send(m) }



