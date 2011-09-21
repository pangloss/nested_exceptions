require 'nested_exceptions'

NestedExceptions::GLOBAL = true

[NoMemoryError, ScriptError, SignalException, StandardError, SystemExit].each do |klass|
  klass.send :include, NestedExceptions
end
