# NestedExceptions

This simple library adds support for nested exceptions in Ruby.

## Why?

It can be really painful to debug a situation where a library rescues an
exception and throws a different one, or when it has a bug in its
exception handling logic. This gem goes a diving catch and recovers the
play!

The best way to learn more about this topic is to investigate the great
source of information at the [Exceptional Ruby](http://exceptionalruby.com/) site.

## How do I use it?

The best way to use it is to simply add the following line of code to
your project:

    require 'nested_exceptions/global'

That includes the NestedExceptions module in all of Ruby's base
exception classes (except the Exception root class), magically enabling
you to debug the trickiest, buggiest libraries.

### I'm not sure I want to include it globally

If you want to try it out without extending Ruby's exception classes,
you can also do the following:

    require 'nested_exceptions'

    class MyException < StandardError
      include NestedExceptions
    end

That will only extend your class and leave the rest of the exception
classes untouched.

## Does it change anything?

Yes. A bit of extra information is added to your backtraces. In addition
to the standard backtrace, you'll get a little bit of nesting
information.

  `ruby examples/example.rb original`

    examples/example.rb:32:in `rescue in double_bug': oops (RuntimeError)
      from examples/example.rb:30:in `double_bug'
      from examples/example.rb:42:in `<main>'


  `ruby examples/example.rb nested`

    examples/example.rb:30:in `rescue in double_bug': oops (RuntimeError)
      from --- cause: ErrorSpec::InternalError: problem
      from examples/example.rb:20:in `rescue in problem'
      from --- cause: RuntimeError: bug
      from examples/example.rb:10:in `bug'
      from examples/example.rb:14:in `nested_bug'
      from examples/example.rb:18:in `problem'
      from examples/example.rb:24:in `nested_problem'
      from examples/example.rb:28:in `double_bug'
      from examples/example.rb:35:in `<main>'

It also adds two methods to the exception:

* #root_cause: allows you to easily get the first exception
* #cause: get the exception (if any) that may have caused this one

## Gotchas

Do not include the NestedExceptions module in a subclass before adding
it to its superclass. That will cause the nested exceptions feature to
deactivate itself to prevent a stack overflow.
