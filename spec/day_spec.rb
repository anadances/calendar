require 'spec_helper'

describe Day do
  it 'is initialized with a date' do
    day = Day.new(2013, 3, 5)
    day.should be_an_instance_of Day
  end

  it 'can tell you what day of the week it is' do
    day = Day.new(2013, 3, 5)
    day.weekday.should eq 'Tuesday'
  end

  it 'returns false if there are no events on that day' do
    Event.create(name: 'class', start_date: 20130302, end_date: 20130304)
    day = Day.new(2013, 3, 5)
    day.events?.should be_false
  end

  it 'returns true if there are events on that day' do
    Event.create(name: 'class', start_date: 20130304, end_date: 20130306)
    day = Day.new(2013, 3, 5)
    day.events?.should be_true
  end

  it 'shows you all its events' do
    event = Event.create(name: 'class', start_date: 20130304, end_date: 20130306)
    day = Day.new(2013, 3, 5)
    day.events.should eq [event]
  end

  it 'is equal to another day if the year, month and day are the same' do
    day1 = Day.new(2013, 3, 5)
    day2 = Day.new(2013, 3, 5)
    day1.should eq day2
  end

  it 'returns an empty array if there are no events that day' do
    day = Day.new(2013, 3, 5)
    day.events.should eq []
  end

  it 'returns both one-time and repeating events' do
    event = Event.create(name: 'thing_two', start_date: 20130305, end_date: 20130306)
    Repeat.create(daily: true, event: event)
    day = Day.new(2014, 3, 7)
    day.events.should eq [event]
  end

  it 'does not return duplicate events' do
    event = Event.create(name: 'thing_one', start_date: 20130305, end_date: 20130306)
    Repeat.create(daily: true, event: event)
    day = Day.new(2013, 3, 5)
    day.events.should eq [event]
  end
end





