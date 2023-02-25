class Exam < ApplicationRecord
  belongs_to :school_subject
  belongs_to :user
  has_many :questions, dependent: :destroy

  validates :title, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[title]
  end
end
