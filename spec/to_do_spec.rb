require 'spec_helper'

describe ToDo do
  it {should have_many :notes}  
  it {should validate_presence_of :name}
end