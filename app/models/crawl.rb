class Crawl < ApplicationRecord
  belongs_to :user

  before_save :geocode_endpoints

  validates :start_location, presence: true
  validates :end_location, presence: true
  validates :pub_number, presence: true

  private

  def geocode_endpoints
    if start_location_changed?
      geocoded = Geocoder.search(start_location).first
      if geocoded
        self.start_longitude = geocoded.longitude
        self.start_latitude = geocoded.latitude
      end
    end
    if end_location_changed?
      geocoded = Geocoder.search(end_location).first
      if geocoded
        self.end_longitude = geocoded.longitude
        self.end_latitude = geocoded.latitude
      end
    end
  end
end
