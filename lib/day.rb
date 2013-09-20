class Day
  attr_reader :year, :month, :day, :weekday
  def initialize(year, month, day)
    @year = year
    @month = month
    @day = day
    @date = Date.new(@year, @month, @day)
    @weekday = @date.strftime('%A')
  end

  def events?
    events.exists?
  end

  def events
    results = Event.unscoped.where("start_date <= ? AND end_date >= ?", @date, @date)
    Repeat.where("day_of_month = ? OR weekday = ? OR daily = ?", @day, @weekday, true).each {|repeat| results << repeat.event}
    results.uniq.length == 0 ? results : results.uniq
  end

  def ==(other)
    @year == other.year && @month == other.month && @day == other.day
  end
end