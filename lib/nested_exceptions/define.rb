module NestedExceptions
  class << self
    # Define a set of standard exception classes as recommended in
    # http://exceptionalruby.com/
    #
    # I actually recommend that you just define these manually, but this may be
    # a handy shortcut in smaller projects.
    def define_standard_exception_classes_in(target_module)
      definitions = %{
        class Error < StandardError; include NestedExceptions; end
          class UserError < Error; end
          class LogicError < Error; end
            class ClientError < LogicError; end
            class InternalError < LogicError; end
          class TransientError < Error; end
      }
      target_module.module_eval definitions
      [:Error, :UserError, :LogicError, :ClientError, :InternalError, :TransientError].map do |name|
        target_module.const_get name
      end
    end
  end
end
