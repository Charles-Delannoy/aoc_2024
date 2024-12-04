require_relative '../input_parser.rb' # custom parsing method for the input

class TShirt 
  DIRECTIONS = %i[right left top bottom diagonal_bottom_right diagonal_bottom_left diagonal_top_left diagonal_top_right].freeze

  def initialize(letter_lines)
    @letter_lines = letter_lines
    @index_max = letter_lines.first.size - 1
  end

  def xmas_count
    count = 0
    letter_positions('X').each do |positions|
      DIRECTIONS.each do |direction|
        count += 1 if xmas?(positions, direction)
      end
    end
    count
  end

  def xmas?(position , direction)
    x, y = position
    case direction
    when :right
      return false if @letter_lines[x][y + 3].nil?
      return @letter_lines[x][y..(y+3)] == 'XMAS'
    when :left
      return false if (y-3) < 0 || @letter_lines[x][y - 3].nil?
      return @letter_lines[x][(y-3)..y].reverse == 'XMAS'
    when :top
      return false if (x-3) < 0 || @letter_lines[x - 3].nil?
      return @letter_lines[(x-3)..x].map { |line| line[y] }.join.reverse == 'XMAS'
    when :bottom
      return false if @letter_lines[x + 3].nil?
      return @letter_lines[x..(x+3)].map { |line| line[y] }.join == 'XMAS'
    when :diagonal_bottom_right
      return false if @letter_lines[x + 3].nil? || @letter_lines[x + 3][y + 3].nil?
      i = -1
      @letter_lines[x..(x+3)].map do |line|   
        i += 1
        line[y + i]
      end.join == 'XMAS'
    when :diagonal_bottom_left
      return false if (y-3) < 0 || @letter_lines[x + 3].nil? || @letter_lines[x + 3][y - 3].nil?
      i = -1
      @letter_lines[x..(x+3)].map do |line|   
        i += 1
        line[y - i]
      end.join == 'XMAS'
    when :diagonal_top_left
      return false if (x-3) < 0 || (y-3) < 0 || @letter_lines[x - 3].nil? || @letter_lines[x - 3][y - 3].nil?
      i = 4
      @letter_lines[(x-3)..x].map do |line|   
        i -= 1
        line[y - i]
      end.join.reverse == 'XMAS'
    when :diagonal_top_right
      return false if (x-3) < 0 || @letter_lines[x - 3].nil? || @letter_lines[x - 3][y + 3].nil?
      i = 4
      @letter_lines[(x-3)..x].map do |line|   
        i -= 1
        line[y + i]
      end.join.reverse == 'XMAS'
    end
  end

  def x_max_count
    count = 0
    letter_positions('A').each do |position|
      count += 1 if x_max?(position)
    end
    count
  end

  def x_max?(position)
    x, y = position
    return false if x == 0 || x == @index_max || y == 0 || y == @index_max
    cross_1 = [@letter_lines[x+1][y+1], @letter_lines[x][y], @letter_lines[x-1][y-1]].join
    cross_2 = [@letter_lines[x+1][y-1], @letter_lines[x][y], @letter_lines[x-1][y+1]].join
    (cross_1 == 'MAS' || cross_1 == 'SAM') && (cross_2 == 'MAS' || cross_2 == 'SAM')
  end

  def letter_positions(letter)
    pos = []
    @letter_lines.each_with_index do |line, x|
      (0..@index_max).to_a.each do |y|
        pos << [x,y] if line[y] == letter
      end
    end
    pos
  end
end

letter_lines = InputParser.array("day4/input.txt")
t_shirt = TShirt.new(letter_lines)
puts "Part 1: #{t_shirt.xmas_count}"
puts "Part 2: #{t_shirt.x_max_count}"