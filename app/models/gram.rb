class Gram < ApplicationRecord
  validates :message, presence: true
  validates :photo, presence: true

  
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  has_many :comments
end
