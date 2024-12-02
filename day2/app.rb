require_relative '../input_parser.rb' # custom parsing method for the input

class GlobalReport 
  def initialize(raw_reports, dampener: false)
    @dampener = dampener
    @reports = reports(raw_reports)
  end

  def safe_reports
    @reports.select { |report| report.safe? }
  end

  private 

  def reports(raw_reports)
    raw_reports.map do |raw_report|
      Report.new(raw_report, dampener: @dampener)
    end
  end
end

class Report
  def initialize(raw_report, dampener: false)
    @raw_report = raw_report
    @dampener = dampener
  end

  def safe?
    return safe_report?(@raw_report) unless @dampener

    dampener_safe?
  end

  private

  def dampener_safe?
    report = @raw_report.dup
    (@raw_report.size + 1).times do |i|
      return safe_report?(report) if safe_report?(report)
      
      report = report_without_item_at(i - 1)
    end
    false
  end

  def safe_report?(report)
    sorted?(report) && safe_diff?(report)
  end

  def sorted?(report)
    report == report.sort || report == report.sort.reverse
  end

  def safe_diff?(report)
    report.each_cons(2).map { |a, b| (a-b).abs }.all? { |diff| diff.positive? && diff <= 3 }
  end

  def report_without_item_at(item_position)
    report = @raw_report.dup
    report.delete_at(item_position)
    report
  end
end

raw_levels = InputParser.array("day2/input.txt", integers: true)
puts "Part 1: #{GlobalReport.new(raw_levels).safe_reports.size}"
puts "Part 2: #{GlobalReport.new(raw_levels, dampener: true).safe_reports.size}"