class Animal < ApplicationRecord
  has_many :sightings, dependent: :destroy
end
