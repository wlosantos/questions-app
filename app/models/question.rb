class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy

  validates :ask, presence: true

  after_initialize :basic_response

  def self.ransackable_attributes(_auth_object = nil)
    %w[ask]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[answers]
  end

  private

  def basic_response
    return unless answers.empty?

    answers.build(response: 'none of the alternatives!', corrected: true)
  end
end
