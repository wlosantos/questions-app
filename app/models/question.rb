class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy

  validates :ask, presence: true
  before_validation :blocked_new_question, on: :create

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

  def blocked_new_question
    return false if exam.nil?
    return true unless exam.blocked?

    errors.add(:base, 'You cannot add a new question to this exam') if exam.blocked?
    false
  end
end
