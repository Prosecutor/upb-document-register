class Document < ApplicationRecord
  has_many_attached :files

  belongs_to :user

  scope :with_user_id, ->(user_id) { where(user_id: user_id) }
end
