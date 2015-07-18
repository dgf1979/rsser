require 'spec_helper'

describe "Hash#fetch_first_matching" do
  it "returns the first matching key given an array of possible keys" do
    h = { one: 1, two: 2, three: 3 }
    expect(h.fetch_first_matching([ :nope, 'not this', :two, :one, :three ])).to eql(2)
  end

  it "returns nil if none of the given keys exist" do
    h = { one: 1, two: 2, three: 3 }
    expect(h.fetch_first_matching([ :nope, 'not this' ])).to eql(nil)
  end
end
