# This is a brute force implementation of the traveling salesman problem.
# The cities are situated within a 20 by 20 grid, ranging from -10 to 10 on both
# the x and y axis. The distance between any two cities are calculated using the
# Pythagorean Theorem (c = Math.sqrt(a**2 + b**2)). The algorithm calculates the distances
# of all possible routes and picks the shortest one. This is not a scalable solution
# since the number of possibilities is the factorial of the number of cities. Some of
# the possible optimizations could include a more efficient Array#generate_permutations method,
# clustering of nearby nodes into one node, and early elimination of inprobable routes (choosing the farthest city
# right after the starting city, etc.)

# Custom implementation of ruby's Array#permutation.
class Array
  def generate_permutations
    return [self] if self.size < 2
    permutation = []
    self.each do |element|
      (self - [element]).generate_permutations.each do |perm_accumulator|
        permutation.push ([element] + perm_accumulator)
      end
    end
    permutation
  end
end

class City
  attr_reader :coords
  def initialize(coords, beginning_city=false)
    @beginning_city = beginning_city
    @coords = coords
    self.check_coords_range!
  end

  def check_coords_range!
    coords.each {|coord| raise "Please place the city within the range of -10 and 10!" if (coord > 10 or coord < -10)}
  end

end

class SalesMan
  attr_reader :starting_city
  def initialize(args)
    @starting_city = args[:starting_city]
  end
end

class Algorithm
  attr_reader :cities, :salesman, :starting_city
  def initialize(salesman)
    @starting_city = salesman.starting_city
    @cities = 5.times.collect { City.new([rand(-10..10), rand(-10..10)]) }
    @salesman = salesman
  end

  def run
    results = {}
    generate_index_permutations.each do |permutation|
      results[self.calculate_total_distance(permutation)] = permutation
    end
    results
  end


  def generate_index_permutations
    #permutations of cities without the home city in beginning and end.
    (0..self.cities.length-1).to_a.generate_permutations
  end

  def calculate_distance_to_next_city(current_city, next_city)
    #calculate the distance between any two points on a graph using Pythagorean Theorem.
    Math.sqrt((current_city.coords[0] - next_city.coords[0])**2 + (current_city.coords[1] - next_city.coords[1])**2)
  end

  def calculate_total_distance(permutation)
    total = 0
    permutation.each_with_index do |perm_index, index|
      if index == 0
        total += calculate_distance_to_next_city(self.starting_city, self.cities[perm_index])
        total += calculate_distance_to_next_city(self.cities[perm_index], self.cities[permutation[index+1]])
      elsif index == permutation.length - 1
        total += calculate_distance_to_next_city(self.cities[perm_index], self.starting_city)
      else
        total += calculate_distance_to_next_city(self.cities[perm_index], self.cities[permutation[index+1]])
      end
    end
    total
  end

  def render(results)
    route = results[results.keys.min]
    puts "The shortest route is as follows (in x-y coordinates) at #{results.keys.min.round(2)} miles"
    puts "Starting City: #{self.starting_city.coords}"
    route.each_with_index {|coord, index| puts "City #{index+1}: #{self.cities[coord].coords}"}
    puts "Starting City: #{self.starting_city.coords}"
  end
end


salesman = SalesMan.new(starting_city: City.new([rand(-10..10), rand(-10..10)], true))
algo = Algorithm.new(salesman)
results = algo.run
algo.render(results)