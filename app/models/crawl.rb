class Crawl < ApplicationRecord
  belongs_to :user

  geocoded_by :start_location
  geocoded_by :end_location
  after_validation :geocode, if: :will_save_change_to_start_location?
  after_validation :geocode, if: :will_save_change_to_end_location?

  validates :start_location, presence: true
  validates :end_location, presence: true
  validates :pub_number, presence: true
end
