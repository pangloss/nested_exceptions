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
  begin
    example.double_bug
  rescue StandardError => e
    if Object.const_defined? :RUBY_ENGINE and (RUBY_ENGINE == 'jruby' or RUBY_ENGINE == 'rbx')
      puts "Note that JRuby and Rubinius do not display the modified backtrace:"
      pp e.backtrace
      puts
    end
    puts "Nested exception:"
    raise
  end

else

  puts "Usage:"
  puts
  puts "ruby #{ $0 } [original|nested]"

end

