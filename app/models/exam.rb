class Exam < ApplicationRecord
  belongs_to :subject
  has_many :questions, dependent: :destroy

  validates :theme, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[theme status]
  end
end
