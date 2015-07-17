require 'rails_helper'

describe Feed do
  it { should validate_presence_of :rss }
  it { should validate_presence_of :title }
  it { should have_many :items }
end
