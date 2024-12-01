require_relative '../input_parser.rb' # custom parsing method for the input

class LocationsList
  def initialize(location_lists)
    @first_list = location_lists.first
    @second_list = location_lists.last
    @list_size = @first_list.size
  end

  def total_distance
    @first_list.each_with_index.reduce(0) do |total_distance, (left_id, index)|
      total_distance += distance(left_id, @second_list[index])
    end
  end

  def similarity_score 
    occurences = @second_list.group_by(&:itself)
    @first_list.reduce(0) do |score, location_id|
      score += occurences[location_id] ? location_id * occurences[location_id].size : 0
    end
  end

  private 

  def distance(left_id, right_id)
    (left_id - right_id).abs
  end
end

input_lists = InputParser.array("day1/input.txt", integers: true).transpose.map(&:sort)
location_list = LocationsList.new(input_lists)
puts "Part 1: #{location_list.total_distance}"
puts "Part 2: #{location_list.similarity_score}"