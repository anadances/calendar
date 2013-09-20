require "active_record"
require "textacular"

require "./lib/event"
require "./lib/day"
require "./lib/calendar"
require "./lib/note"
require "./lib/to_do"
require "./lib/repeat"

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])
ActiveRecord::Base.extend(Textacular)

def welcome
  puts `clear`
  puts ""
  puts ""
  puts "       Welcome to the Calendar"
  puts ""
  gets
  menu
end

def menu
  input = nil
  until input == 'x'
    puts `clear`
    puts "Manage Events:"
    puts "  [C]reate , [E]dit, [D]elete, or [V]iew"
    puts ""
    puts "Manage To-Dos:"
    puts "  [A]dd, [R]emove, or [S]ee"
    puts ""
    puts "Searc[h] all entries or e[x]it program"
    input = gets.chomp.downcase.strip
    case input
    when 'c'
      create_event
    when 'e'
      edit_events
    when 'd'
      delete_event
    when 'v'
      view_events
    when 'a'
      create_to_do
    when 's'
      view_to_dos
    when 'r'
      delete_to_do
    when 'h'
      search_all
    when 'x'
      puts "good bye"
    end 
  end 
end

def create_event
  puts `clear`
  puts "What is the name of the event you'd like to add?"
  name = gets.chomp
  puts "What is the start date of the event? Include month, day and year"
  start_date = gets.chomp
  puts "What is the end date of the event? Include month, day and year"
  end_date = gets.chomp
  puts "What time is the event at?"
  time = gets.chomp
  puts "Where is the event happening?"
  location = gets.chomp
  event = Event.create(name: name, start_date: start_date, end_date: end_date, time: time, location: location)
  puts "Does this event repeat? (y/n)"
  if gets.chomp.downcase.strip[0] == 'y'
    puts "How often does it repeat? [d]aily, [w]eekly, [m]onthly"
    frequency = gets.chomp.downcase.strip
    if frequency == 'd'
      Repeat.new(daily: true, event: event)
    elsif frequency == 'w'
      Repeat.new(weekday: Date.parse(start_date).strftime('%A'), event: event)
    elsif frequency == 'm'
      Repeat.new(day_of_month: Date.parse(start_date).strftime('%-d'), event: event)
    end
  end
  puts "Would you like to add any notes? (y/n)"
  if gets.chomp.downcase.strip[0] == 'y'
    add_note(event)
  end
end

def edit_events
  puts `clear`
  puts "Events:"
  Event.all.each_with_index {|event, index| puts "  #{index + 1}. #{event.name}"}
  puts ""
  puts "Enter the index of an event to edit or return to [m]ain menu"
  selection = gets.chomp.to_i
  if selection > 0 && selection <= Event.all.length
    edit_event(Event.all[selection - 1])
  elsif selection != 0
    edit_events
  end
end

def edit_event(event)
  selection = nil
  until selection == 'f'
    puts `clear`
    puts "#{event.name}"
    start_date = pretty_date(event.start_date)
    end_date = pretty_date(event.end_date)
    puts "  Starts: #{start_date}"
    puts "  Ends: #{end_date}"
    if event.time.nil?
      time = ""
    else
      time = "#{event.time.hour}:" + "#{event.time.min}".ljust(2, '0')
    end
    puts "  Time: #{time}"
    location = event.location || ""
    puts "  Location: #{location}"
    if event.notes.length != 0
      puts "  Notes:"
      event.notes.each {|note| puts "    #{note.name}"}
    end
    puts ""
    puts "Edit [n]ame, [s]tart date, [e]nd date, [t]ime, or [l]ocation, or [f]inished editing event" #ADD EDIT NOTES OPTION?
    selection = gets.chomp.downcase.strip
    case selection
    when 'n'
      puts "Enter the event's new name"
      event.update(name: gets.chomp)
    when 's'
      puts "Enter the event's new start date (include year, month, and day)"
      event.update(start_date: gets.chomp)
    when 'e'
      puts "Enter the event's new end date (include year, month, and day)"
      event.update(end_date: gets.chomp)
    when 't'
      puts "Enter the event's new time"
      event.update(time: gets.chomp)
    when 'l'
      puts "Enter the event's new location"
      event.update(location: gets.chomp)
    when 'f'
      edit_events
    end
  end
end

def view_events
  puts `clear`
  puts "Events:"
  Event.all.each_with_index {|event, index| puts "  #{index + 1}. #{event.name}"}
  puts ""
  puts "View events by [d]ay, [w]eek, [m]onth, enter an event's index to view/edit that event, or [r]eturn to main menu"
  selection = gets.chomp.downcase.strip
  if selection == 'd'
    puts "Enter a date to view (include month, day, and year)"
    view_day(Date.parse(gets.chomp))
  elsif selection == 'w'
    puts "Enter a date of a week to view (include month, day, and year)"
    view_week(Date.parse(gets.chomp))
  elsif selection == 'm'
    puts "Enter a date of a month to view (include month, day, and year)"
    view_month(Date.parse(gets.chomp))
  elsif selection.to_i > 0 && selection.to_i <= Event.all.length
    edit_event(Event.all[selection.to_i - 1])
  elsif selection != 'r'
    view_events
  end
end

def view_day(date)
  puts `clear`
  puts pretty_date(date)
  puts ""
  puts "Events:"
  calendar = Calendar.new(date, 'day')
  calendar.events.each_with_index {|event, index| puts "  #{index + 1}. #{event.name}"}
  puts ""
  puts "View the [p]revious or [n]ext day, enter the index of an event to view to edit that event, or return to [m]ain menu"
  selection = gets.chomp.downcase.strip
  if selection == 'p'
    view_day(date.prev_day)
  elsif selection == 'n'
    view_day(date.next)
  elsif selection.to_i > 0 && selection.to_i <= calendar.events.length
    edit_event(calendar.events[selection.to_i - 1])
  elsif selection != 'm'
    view_day(date)
  end
end

def view_week(date)
  puts `clear`
  calendar = Calendar.new(date, 'week')
  puts "Week of: #{pretty_date(Date.new(calendar.days[0].year, calendar.days[0].month, calendar.days[0].day))}"
  puts ""
  puts "Events:"
  calendar.events.each_with_index {|event, index| puts "  #{index + 1}. #{event.name}"}
  puts ""
  puts "View the [p]revious or [n]ext week, enter the index of an event to view to edit that event, or return to [m]ain menu"
  selection = gets.chomp.downcase.strip
  if selection == 'p'
    view_week(date.prev_day(7))
  elsif selection == 'n'
    view_week(date.next_day(7))
  elsif selection.to_i > 0 && selection.to_i <= calendar.events.length
    edit_event(calendar.events[selection.to_i - 1])
  elsif selection != 'm'
    view_week(date)
  end
end

def view_month(date)
  puts `clear`
  calendar = Calendar.new(date, 'month')
  puts "#{date.strftime('%B')} #{date.strftime('%Y')}"
  puts ""
  puts "Events:"
  calendar.events.each_with_index {|event, index| puts "  #{index + 1}. #{event.name}"}
  puts ""
  puts "View the [p]revious or [n]ext month, enter the index of an event to view to edit that event, or return to [m]ain menu"
  selection = gets.chomp.downcase.strip
  if selection == 'p'
    view_month(date.prev_month)
  elsif selection == 'n'
    view_month(date.next_month)
  elsif selection.to_i > 0 && selection.to_i <= calendar.events.length
    edit_event(calendar.events[selection.to_i - 1])
  elsif selection != 'm'
    view_month(date)
  end
end

def delete_event
  puts `clear`
  puts "Events:"
  Event.all.each_with_index {|event, index| puts "  #{index + 1}. #{event.name}"}
  puts ""
  puts "Enter the number of the event to delete or return to [m]ain menu"
  index = gets.chomp.to_i
  if index > 0 && index <= Event.all.length
    Event.all[index - 1].destroy
    delete_event
  end
end

def create_to_do
  puts `clear`
  puts "Enter the to_do item to save"
  to_do = gets.chomp
  puts "Would you like to add a note? (y/n)"
  to_do = ToDo.create(name: to_do)
  if gets.chomp.downcase.strip[0] == 'y'
    add_note(to_do)
  end
  puts "Your to_do item has been created"
  gets
end

def view_to_dos
  puts `clear`
  puts "To-Do Items:"
  ToDo.all.each_with_index do |to_do, index|
    puts "  #{to_do.name}"
    to_do.notes.each {|note| puts "    #{note.name}"}
  end
  puts ""
  puts "Return to [m]ain menu"
  gets
end

def delete_to_do
  puts `clear`
  puts "To-Do Items:"
  ToDo.all.each_with_index {|to_do, index| puts "#{index + 1}. #{to_do.name}"}
  puts ""
  puts "Enter the number of the to_do to delete or return to the [m]ain menu"
  number = gets.chomp.to_i
  if number > 0 && number <= ToDo.all.length
    ToDo.all[number - 1].destroy
    delete_to_do
  end
end

def add_note(subject)
  puts "Enter the note you would like to add or [f]inish"
  note = gets.chomp
  if note != 'f'
    Note.create(name: note, notable: subject)
    add_note(subject)
  end  
end

def pretty_date(date)
  "#{date.strftime('%a')}, #{date.strftime('%b')} #{date.strftime('%-d')}, #{date.strftime('%Y')}"
end

def search_all
  puts `clear`
  puts "Enter the text you want to search for."
  search = gets.chomp
  result = Event.basic_search(search)
  result.concat(Note.basic_search(search))
  result.concat(ToDo.basic_search(search))
  puts `clear`
  puts "Search: #{search}"
  puts ""
  puts "Found:"
  result.each {|result| puts "  #{result.name} (#{result.class})"}
  puts ""
  puts "Perform [a]nother search or return to [m]ain menu"
  if gets.chomp.downcase.strip == 'a'
    search_all
  end
end

welcome











