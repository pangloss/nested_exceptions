require "nested_exceptions/version"
require "nested_exceptions/define"

# Just include this module in your custom exception class
module NestedExceptions
  attr_reader :cause

  def initialize(message = nil, cause = nil)
    @cause = cause || $!
    super(message)
  end

  if Object.const_defined? :RUBY_ENGINE and RUBY_ENGINE == 'jruby'
    def backtrace
      return @processed_backtrace if defined? @processed_backtrace and @processed_backtrace
      @processed_backtrace = process_backtrace(super)
    end
  else
    def set_backtrace(bt)
      super process_backtrace(bt)
    end
  end

  def root_cause
    rc = e = self
    while e
      rc = e
      break unless e.respond_to? :cause
      e = e.cause
    end
    rc
  end

  protected

  def process_backtrace(bt)
    if cause
      cause.backtrace.reverse.each do |line|
        if bt.last == line
          bt.pop
        else
          break
        end
      end
      bt << "--- cause: #{cause.class.name}: #{cause}"
      bt.concat cause.backtrace
    end
    bt
  end
end
