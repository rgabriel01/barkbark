class Dog < ApplicationRecord
  has_many_attached :images
  has_many :likes
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
end
