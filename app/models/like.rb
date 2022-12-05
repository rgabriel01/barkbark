class Like < ApplicationRecord
  validates_presence_of :dog_id, :user_id
  belongs_to :dog
  belongs_to :user
end
