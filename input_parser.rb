class InputParser
  class << self
    def array(file_path, **options)
      lines = File.foreach("#{__dir__}/#{file_path}")
      input = lines.reduce([]) { |array, line| array << line.strip }
      cast_to_integers(input, ' ') if options[:integers]
      input
    end

    def cast_to_integers(array, separator)
      array.map! { |pair| pair.split(separator).map(&:to_i) }
    end
  end
end