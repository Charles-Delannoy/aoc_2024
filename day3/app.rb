require_relative '../input_parser.rb' # custom parsing method for the input

class Memory 
  MULS_REGEX = /(mul\(\d*\,\d+\))/
  MULS_CLEANUP_REGEX = /(mul|\(|\))/
  DONT_REGEX = /(don\'t\(\))/
  DO_REGEX = /(do\(\))/

  def initialize(memory, conditions: false)
    @memory = memory
    @mul_positions = mul_positions
    @dont_positions = positions(DONT_REGEX)
    @do_positions = positions(DO_REGEX)
    @conditions = conditions
  end

  def multiplication
    @mul_positions.reduce(0) do |res, (mul, position)| 
      mul_array = mul_str_to_integers(mul)
      res += valid_mul?(position) ? (mul_array.first * mul_array.last) : 0
    end
  end

  private

  def mul_positions
    positions = positions(MULS_REGEX)
    mul_positions = {}
    @memory.scan(MULS_REGEX).flatten.each_with_index do |match, index|
      mul_positions[match] = positions[index]
    end
    mul_positions
  end

  def positions(regex)
    @memory.enum_for(:scan, regex).map { Regexp.last_match.begin(0) }
  end

  def valid_mul?(position)
    return true if !@conditions

    last_dont = last_pos_before(@dont_positions, position)
    last_do = last_pos_before(@do_positions, position)
    return true if (last_do.nil? && last_dont.nil?) || last_dont.nil?

    last_do > last_dont if last_do && last_dont
  end

  def last_pos_before(positions, position)
    positions.reverse.find { |pos| pos < position }
  end

  def mul_str_to_integers(mul)
    mul.gsub(MULS_CLEANUP_REGEX, '').split(',').map(&:to_i)
  end
end

memory = InputParser.string("day3/input.txt")
puts "Part 1: #{Memory.new(memory).multiplication}"
puts "Part 2: #{Memory.new(memory, conditions: true).multiplication}"

