require_relative '../input_parser.rb' # custom parsing method for the input

class UpdatesRulesChecker
  attr_reader :rules
  def initialize(rules, updates)
    @rules = rules_per_number(rules) 
    @updates = instanciate_updates(updates)
  end

  def middle_page_sum(correct_updates:)
    updates = correct_updates ? filter_update_by(correct_order: true) : filter_update_by(correct_order: false).map(&:fixed)
    updates.map { |update| update.middle_page }.sum 
  end

  def filter_update_by(correct_order:)
    correct_order ? @updates.select(&:correct_order?) : @updates.reject(&:correct_order?)
  end

  private

  def rules_per_number(rules)
    rules_per_number = {}
    rules.each do |rule|
      number = rule.first
      rules_per_number[number] ||= []
      rules_per_number[number] << rule.last
    end
    rules_per_number
  end

  def instanciate_updates(updates)
    updates.map do |update|
      Update.new(update, @rules)
    end
  end
end

class Update
  def initialize(update, rules)
    @update = update
    @rules = rules    
  end

  def middle_page
    @update[@update.size/2]
  end

  def fixed
    original_update = @update.dup
    until correct_order?
      incorrect_page = first_incorrect_page
      current_index = @update.index(incorrect_page)
      new_index = min_index(@rules[incorrect_page])
      @update.insert(new_index, @update.delete_at(current_index))
    end
    fixed_update = self.dup
    @update = original_update
    fixed_update
  end

  def correct_order?
    already_met = []
    @update.each do |page|
      if @rules.keys.include? page
        return false unless (already_met - @rules[page]) == already_met
      end
      already_met << page
    end
    true
  end

  def first_incorrect_page 
    already_met = []
    @update.find do |page| 
      is_wrong = @rules.keys.include?(page) && (already_met - @rules[page]) != already_met
      already_met << page
      is_wrong
    end
  end

  def min_index(pages)
    pages.map { |page| @update.index(page) }.compact.min
  end
end

rules, updates = InputParser.array("day5/input.txt").partition { |e| e.include?('|') }
rules = InputParser.cast_to_integers(rules, '|')
updates = InputParser.cast_to_integers(updates.reject(&:empty?), ',')
updates_rules_checker = UpdatesRulesChecker.new(rules, updates)

puts "Part 1: #{updates_rules_checker.middle_page_sum(correct_updates: true)}"
puts "Part 2: #{updates_rules_checker.middle_page_sum(correct_updates: false)}"