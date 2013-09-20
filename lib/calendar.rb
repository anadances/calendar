class Calendar
  attr_reader :days, :events, :days_in_month

  def initialize(date, span)
    @date = date
    @year = @date.strftime('%Y').to_i
    @month = @date.strftime('%-m').to_i
    @day = @date.strftime('%-d').to_i
    @days_in_month = {1 => 31, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31}
    @days_in_month[2] = Date.leap?(@year) ? 29 : 28

    if span == 'week'
      generate_week
    elsif span == 'day'
      @days = [Day.new(@year, @month, @day)]  
      @events = @days[0].events
    elsif span == 'month'
      generate_month
    end
  end

private

  def generate_month
    @days, @events = [], []
    @days_in_month[@month].times do |index|
      @days << Day.new(@year, @month, index + 1)
      @events.concat(@days[index].events)
    end
    @events.uniq!
  end
  
  def generate_week
    start_of_week
    @days, @events = [], []
    7.times do |index|
      @days << Day.new(@year, @month, @day)
      @events.concat(@days[index].events)
      next_day
    end
    @events.uniq!
  end

  def start_of_week
    while @date.strftime('%A') != 'Sunday'
      previous_day
    end
  end

  def next_day
    @date = @date.next
    @year = @date.strftime('%Y').to_i
    @month = @date.strftime('%-m').to_i
    @day = @date.strftime('%-d').to_i
  end

  def previous_day
    @date = @date.prev_day
    @year = @date.strftime('%Y').to_i
    @month = @date.strftime('%-m').to_i
    @day = @date.strftime('%-d').to_i
  end
end