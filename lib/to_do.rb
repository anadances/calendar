class ToDo < ActiveRecord::Base
  has_many :notes, as: :notable
  validates :name, presence: true
end