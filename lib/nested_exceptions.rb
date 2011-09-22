require "nested_exceptions/version"
require "nested_exceptions/define"

# Just include this module in your custom exception class
module NestedExceptions
  attr_reader :cause

  def initialize(message = nil, cause = nil)
    # @cause could be defined if this module is included multiple
    # times in a class heirarchy.
    @illegal_nesting = defined? @cause
    @recursing = false
    if @illegal_nesting
      warn "WARNING: NestedExceptions is included in the class heirarchy of #{ self.class } more than once."
      warn "- Ensure if you require 'nested_exceptions/global' or manually add"
      warn "  NestedExceptions to a built-in Ruby exception class, you must do it at"
      warn "  the beginning of the program."
    else
      @cause = cause || $!
      super(message)
    end
  end

  if Object.const_defined? :RUBY_ENGINE and (RUBY_ENGINE == 'jruby' or RUBY_ENGINE == 'rbx')
    def backtrace
      prevent_recursion do
        return @processed_backtrace if defined? @processed_backtrace and @processed_backtrace
        @processed_backtrace = process_backtrace(super)
      end
    end
  else
    def set_backtrace(bt)
      prevent_recursion do
        super process_backtrace(bt)
      end
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

  # This shouldn't be necessary anymore
  def prevent_recursion
    if not @recursing and not @illegal_nesting
      begin
        @recursing = true
        yield
      ensure
        @recursing = false
      end
    end
  end

  def process_backtrace(bt)
    bt ||= []
    if @cause and not @illegal_nesting
      cause_backtrace = @cause.backtrace || []
      cause_backtrace.reverse.each do |line|
        if bt.last == line
          bt.pop
        else
          break
        end
      end
      bt << "--- cause: #{@cause.class}: #{@cause}"
      bt.concat cause_backtrace
    end
    bt
  rescue Exception => e
    warn "exception processing backtrace: #{ e.class }: #{ e.message }\n  #{ caller(0).join("\n  ") }"
  end
end
