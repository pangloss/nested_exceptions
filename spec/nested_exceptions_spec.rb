require 'spec_helper'

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

describe NestedExceptions do
  let(:ex) { ErrorSpec::Example.new }
  def in_rescue
    if Object.const_defined? :RUBY_ENGINE and RUBY_ENGINE == 'jruby'
      ''
    elsif RUBY_VERSION =~ /^1\.[0-8]\./
      ''
    else
      in_rescue = 'rescue in '
    end
  end

  it 'should create a stack trace correctly' do
    stack = raise rescue $!.backtrace
    stack.first.should =~ /#{__FILE__}:#{__LINE__ - 1}/
  end

  describe 'normal StandardError' do
    subject do
      @stack = raise rescue $!.backtrace; ex.bug rescue $!
    end
    its(:message) { should == 'bug' }
    its(:backtrace) { should == ["#{__FILE__}:9:in `bug'"] + @stack }
  end

  describe 'nested InternalError' do
    subject do
      @stack = raise rescue $!.backtrace; ex.problem rescue $!
    end
    its(:message) { should == 'problem' }
    its('root_cause.message') { should == 'bug' }
    its(:backtrace) do
      should == [
        "#{__FILE__}:19:in `#{in_rescue}problem'",
        "--- cause: RuntimeError: bug",
        "#{__FILE__}:9:in `bug'",
        "#{__FILE__}:13:in `nested_bug'",
        "#{__FILE__}:17:in `problem'"
      ] + @stack
    end
  end

  describe 'double nested StandardError' do
    subject do
      @stack = raise rescue $!.backtrace; ex.double_bug rescue $!
    end
    its(:message) { should == 'oops' }
    its('root_cause.message') { should == 'bug' }
    its(:backtrace) do
      should == [
        "#{__FILE__}:29:in `#{in_rescue}double_bug'",
        "--- cause: ErrorSpec::InternalError: problem",
        "#{__FILE__}:19:in `#{in_rescue}problem'",
        "--- cause: RuntimeError: bug",
        "#{__FILE__}:9:in `bug'",
        "#{__FILE__}:13:in `nested_bug'",
        "#{__FILE__}:17:in `problem'",
        "#{__FILE__}:23:in `nested_problem'",
        "#{__FILE__}:27:in `double_bug'"
      ] + @stack
    end
  end
end
