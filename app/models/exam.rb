class Exam < ApplicationRecord
  belongs_to :subject
  has_many :questions, dependent: :destroy

  validates :theme, presence: true
  enum status: { pending: 0, waiting: 1, approved: 2, rejected: 3 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[theme status]
  end
end
