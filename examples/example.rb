require 'pp'

$: << './lib'
require 'nested_exceptions'

module ErrorSpec

  NestedExceptions.define_standard_exception_classes_in ErrorSpec

  class Example
    def bug
      raise 'bug'
    end

    def nested_bug
      bug
    end

    def problem
      nested_bug
    rescue
      raise InternalError, 'problem'
    end

    def nested_problem
      problem
    end

    def double_bug
      nested_problem
    rescue
      raise 'oops'
    end
  end
end

example = ErrorSpec::Example.new

if ARGV.first == 'original'

  puts "Original exception:"
  example.double_bug

elsif ARGV.first == 'nested'

  require 'nested_exceptions/global'
  puts "Nested exception:"
  begin
    example.double_bug
  rescue StandardError => e
    puts "Note that JRuby does not display the modified backtrace:"
    pp e.backtrace
    raise
  end

else

  puts "Usage:"
  puts
  puts "ruby #{ $0 } [original|nested]"

end

