class Question < ApplicationRecord
  belongs_to :exam
  belongs_to :user

  enum status: { blocked: 0, active: 1 }

  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
