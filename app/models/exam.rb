class Exam < ApplicationRecord
  belongs_to :subject
  has_many :questions, dependent: :destroy
  has_many :user_exam, dependent: :destroy

  validates :theme, presence: true
  enum :status, %i[pending approved]

  def self.ransackable_attributes(_auth_object = nil)
    %w[theme status]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[questions subject]
  end
end
