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

  private 

  def distance(left_id, right_id)
    (left_id - right_id).abs
  end
end

location_lists = InputParser.array("day1/input.txt", integers: true).transpose.map(&:sort)

pp LocationsList.new(location_lists).total_distance