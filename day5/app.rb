require_relative '../input_parser.rb' # custom parsing method for the input

class UpdatesRulesChecker
  attr_reader :rules
  def initialize(rules, updates)
    @rules = rules_per_number(rules) 
    @updates = updates
  end

  def wrong_middle_page_sum
    filter_update_by(correct_order: false).map do |update|
      fixed_update = fix(update)
      middle_page(fixed_update)
    end.sum
  end

  def fix(update)
    until correct_order?(update)
      wrong_number = find_first_wrong_number(update)
      current_index = update.index(wrong_number)
      new_index = min_indexe(@rules[wrong_number], update)
      update.insert(new_index, update.delete_at(current_index))
    end
    update
  end

  def min_indexe(numbers, update)
    numbers.map { |number| update.index(number) }.compact.min
  end

  def middle_page_sum(correct_updates:)
    updates = correct_updates ? filter_update_by(correct_order: true) : filter_update_by(correct_order: false)
    return filter_update_by(correct_order: true).map { |update| middle_page(update) }.sum if correct_updates

  end
  
  def correct_middle_page_sum
    filter_update_by(correct_order: true).map { |update| middle_page(update) }.sum
  end

  def filter_update_by(correct_order:)
    return @updates.select { |update| correct_order?(update) } if correct_order
    @updates.reject { |update| correct_order?(update) }
  end

  def middle_page(update)
    update[update.size/2]
  end

  def correct_order?(update)
    already_met = []
    update.each do |page|
      if @rules.keys.include? page
        return false unless (already_met - @rules[page]) == already_met
      end
      already_met << page
    end
    true
  end

  def find_first_wrong_number(update)
    already_met = []
    update.find do |number| 
      is_wrong = @rules.keys.include?(number) && (already_met - @rules[number]) != already_met
      already_met << number
      is_wrong
    end
  end

  def rules_per_number(rules)
    rules_per_number = {}
    rules.each do |rule|
      number = rule.first
      rules_per_number[number] ||= []
      rules_per_number[number] << rule.last
    end
    rules_per_number
  end
end

class Update
  def initialize(update, rules)
    @update = update
    @rules = rules    
  end
end

rules, updates = InputParser.array("day5/input.txt").partition { |e| e.include?('|') }
rules = InputParser.cast_to_integers(rules, '|')
updates = InputParser.cast_to_integers(updates.reject(&:empty?), ',')
updates_rules_checker = UpdatesRulesChecker.new(rules, updates)

puts "Part 1: #{updates_rules_checker.middle_page_sum(correct_updates: true)}"
puts "Part 2: #{updates_rules_checker.wrong_middle_page_sum}"