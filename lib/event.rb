class Event < ActiveRecord::Base
  has_many :repeats
  has_many :notes, as: :notable
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  default_scope { order('start_date') }
end