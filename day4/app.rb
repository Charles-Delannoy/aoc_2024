require_relative '../input_parser.rb' # custom parsing method for the input

class TShirt 
  R = :right
  L = :left
  T = :top 
  B = :bottom 
  BR = :bottom_right
  BL = :bottom_left 
  TL = :top_left 
  TR = :top_right
  DIRECTIONS = [R, L, T, B, BR, BL, TL, TR].freeze


  def initialize(letter_lines, all_direction_word:, cross_word:)
    @letter_lines = letter_lines
    @index_max = letter_lines.first.size - 1
    @all_direction_word = all_direction_word
    @cross_word = cross_word
  end

  def all_direction_word_count
    letter_positions(@all_direction_word[0]).reduce(0) do |count, positions|
      count += DIRECTIONS.select { |direction| all_direction_word?(positions, direction) }.size
    end
  end

  def all_direction_word?(position , direction)
    x, y = position
    case direction
    when R
      return false if @letter_lines[x][y + 3].nil?
      return @letter_lines[x][y..(y+3)] == @all_direction_word
    when L
      return false if (y-3) < 0 || @letter_lines[x][y - 3].nil?
      return @letter_lines[x][(y-3)..y].reverse == @all_direction_word
    when T
      return false if (x-3) < 0 || @letter_lines[x - 3].nil?
      return @letter_lines[(x-3)..x].map { |line| line[y] }.join.reverse == @all_direction_word
    when B
      return false if @letter_lines[x + 3].nil?
      return @letter_lines[x..(x+3)].map { |line| line[y] }.join == @all_direction_word
    when BR
      return false if @letter_lines[x + 3].nil? || @letter_lines[x + 3][y + 3].nil?
      i = -1
      @letter_lines[x..(x+3)].map do |line|   
        i += 1
        line[y + i]
      end.join == @all_direction_word
    when BL
      return false if (y-3) < 0 || @letter_lines[x + 3].nil? || @letter_lines[x + 3][y - 3].nil?
      i = -1
      @letter_lines[x..(x+3)].map do |line|   
        i += 1
        line[y - i]
      end.join == @all_direction_word
    when TL
      return false if (x-3) < 0 || (y-3) < 0 || @letter_lines[x - 3].nil? || @letter_lines[x - 3][y - 3].nil?
      i = 4
      @letter_lines[(x-3)..x].map do |line|   
        i -= 1
        line[y - i]
      end.join.reverse == @all_direction_word
    when TR
      return false if (x-3) < 0 || @letter_lines[x - 3].nil? || @letter_lines[x - 3][y + 3].nil?
      i = 4
      @letter_lines[(x-3)..x].map do |line|   
        i -= 1
        line[y + i]
      end.join.reverse == @all_direction_word
    end
  end

  def cross_word_count
    letter_positions(@cross_word[@cross_word.size/2]).reduce(0) { |count, position| count += cross_word?(position) ? 1 : 0 }
  end

  def cross_word?(position)
    x, y = position
    return false if x == 0 || x == @index_max || y == 0 || y == @index_max
    cross_1 = [@letter_lines[x+1][y+1], @letter_lines[x][y], @letter_lines[x-1][y-1]].join
    cross_2 = [@letter_lines[x+1][y-1], @letter_lines[x][y], @letter_lines[x-1][y+1]].join
    [cross_1, cross_2].all? { |cross| (cross == @cross_word || cross.reverse == @cross_word) }
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
t_shirt = TShirt.new(letter_lines, all_direction_word: 'XMAS', cross_word: 'MAS')
puts "Part 1: #{t_shirt.all_direction_word_count}"
puts "Part 2: #{t_shirt.cross_word_count}"