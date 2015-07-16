require 'rails_helper'

describe Item do
  it { should validate_presence_of :mp3_url }
  it { should validate_presence_of :feed_id }
  it { should validate_presence_of :title }
end
