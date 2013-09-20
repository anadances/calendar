require 'spec_helper'

describe Event do
  it {should have_many :notes}
  it {should validate_presence_of :name}
  it {should validate_presence_of :start_date}
  it {should validate_presence_of :end_date}
  it {should have_many :repeats}

  it 'should list events in chronological order' do
    event1 = Event.create(name: 'third', start_date: 20130306, end_date: 20130401)
    event2 = Event.create(name: 'first', start_date: 20130304, end_date: 20130402)
    event3 = Event.create(name: 'second', start_date: 20130305, end_date: 20130403)
    Event.all[0].name.should eq 'first'
  end

  it 'should list events in chronological order' do
    event1 = Event.create(name: 'third', start_date: 20130306, end_date: 20130401)
    event2 = Event.create(name: 'first', start_date: 20130304, end_date: 20130402)
    event3 = Event.create(name: 'second', start_date: 20130305, end_date: 20130403)
    Event.all[2].name.should eq 'third'
  end
end