require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'textacular'

require 'event'
require 'calendar'
require 'day'
require 'note'
require 'to_do'
require 'repeat'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['test'])
ActiveRecord::Base.extend(Textacular)

RSpec.configure do |config|
  config.after(:each) do
    Event.all.each {|event| event.destroy}
    Note.all.each {|note| note.destroy}
    ToDo.all.each {|to_do| to_do.destroy}
    Repeat.all.each {|repeat| repeat.destroy}
  end
end