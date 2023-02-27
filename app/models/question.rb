class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy

  validates :ask, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[ask]
  end
end
