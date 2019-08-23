class Gram < ApplicationRecord
  validates :message, presence: true
  belongs_to :user
  mount_uploader :photo, PhotoUploader
end
