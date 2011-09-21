module NestedExceptions
  VERSION = "1.0.0"

  def self.const_missing(name)
    if name == 'GLOBAL' or name == :GLOBAL
      NestedExceptions.const_set(name, false)
    else
      super
    end
  end
end
