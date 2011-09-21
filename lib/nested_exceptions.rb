require "nested_exceptions/version"
require "nested_exceptions/define"

# Just include this module in your custom exception class
module NestedExceptions
  attr_reader :cause

  def initialize(message = nil, cause = $!)
    super(message)
    @cause = cause
  end

  def backtrace
    return @processed_backtrace if defined? @processed_backtrace
    @processed_backtrace = super
    if cause
      cause.backtrace.reverse.each do |line|
        if @processed_backtrace.last == line
          @processed_backtrace.pop
        else
          break
        end
      end
      @processed_backtrace << "cause: #{cause.class.name}: #{cause}"
      @processed_backtrace.concat cause.backtrace
    end
    @processed_backtrace
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
end
