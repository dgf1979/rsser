require 'rails_helper'

include FeedsHelper

describe '#fetch_first_matching' do
  it "should return the value of a matching attribute if one exists on the given object" do
    class Test
      attr_reader :one, :two, :three
      def initialize()
        @one   = "1"
        @two   = "2"
        @three = "3"
      end

      def [](key)
        return self.method(key).call
      end
    end
    test_obj = Test.new
    check_for = [ :nope, :two, :not_me ]
    expect(fetch_first_matching(test_obj, check_for)).to eql("2")
  end

  it "should return nil if no given attribute matches" do
    class Test
      attr_reader :one, :two, :three
      def initialize()
        @one   = "1"
        @two   = "2"
        @three = "3"
      end
      def [](key)
        return self.method(key).call
      end
    end

    test_obj = Test.new
    check_for = [ :nope, :not_me ]
    expect(fetch_first_matching(test_obj, check_for)).to eql(nil)
  end
end
