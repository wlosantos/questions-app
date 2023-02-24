class Question < ApplicationRecord
  belongs_to :exam
  belongs_to :user

  has_enumeration_for :status, with: Status, create_helpers: true

  validates :description, presence: true
  validates :status, presence: true
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
