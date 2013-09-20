class Note < ActiveRecord::Base
  belongs_to :notable, polymorphic: true
  validates :name, presence: true
end