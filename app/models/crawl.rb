class Crawl < ApplicationRecord
  belongs_to :user

  validates :start_location, presence: true
  validates :end_location, presence: true
  validates :pub_number, presence: true
end
