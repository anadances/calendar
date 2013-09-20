require 'spec_helper'

describe Note do
  it {should belong_to :notable}
  it {should validate_presence_of :name}
end