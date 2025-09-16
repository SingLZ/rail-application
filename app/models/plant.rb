class Plant < ApplicationRecord
  belongs_to :user

  validates :name, :species, :watering_frequency, presence: true
end
