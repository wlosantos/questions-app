class UserExam < ApplicationRecord
  belongs_to :user
  belongs_to :exam

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
