require 'spec_helper'

describe Calendar do
  it 'is initialized with a year, month, day, and span' do
    calendar = Calendar.new(Date.new(2013, 3, 5), 'day')
    calendar.should be_an_instance_of Calendar
  end

  it 'returns an array of 7 day obects when you give it a span of a week' do
    calendar = Calendar.new(Date.new(2013, 3, 5), 'week')
    day1 = Day.new(2013, 3, 3)
    day2 = Day.new(2013, 3, 4)
    day3 = Day.new(2013, 3, 5)
    day4 = Day.new(2013, 3, 6)
    day5 = Day.new(2013, 3, 7)
    day6 = Day.new(2013, 3, 8)
    day7 = Day.new(2013, 3, 9)
    calendar.days.should eq [day1, day2, day3, day4, day5, day6, day7]
  end

  it 'returns an array of all events within a week when a week is requested' do
    Event.create(name: 'class', start_date: 20130304, end_date: 20130306)
    calendar = Calendar.new(Date.new(2013, 3, 5), 'week')
    calendar.events.length.should eq 1
  end

  it 'generates an array of a day object when a day is requested' do
    calendar = Calendar.new(Date.new(2013, 3, 5), 'day')
    day = Day.new(2013, 3, 5)
    calendar.days.should eq [day]
  end

  it 'returns an array of all events within a day when a day is requested' do
    Event.create(name: 'class', start_date: 20130304, end_date: 20130306)
    calendar = Calendar.new(Date.new(2013, 3, 5), 'day')
    calendar.events.length.should eq 1
  end

  it 'generates one day object for each day in the month when a month is requested' do
    calendar = Calendar.new(Date.new(2013, 3, 5), 'month')
    calendar.days.length.should eq 31
  end

  it 'returns an array of all events for the month in the date specified' do
    Event.create(name: 'class', start_date: 20130304, end_date: 20130306)
    calendar = Calendar.new(Date.new(2013, 3, 5), 'month')  
    calendar.events.length.should eq 1
  end
end