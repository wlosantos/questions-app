class Answer < ApplicationRecord
  belongs_to :question

  validates :description, presence: true
  validates :correct, inclusion: { in: [true, false] }

  before_validation :only_correct_answer

  def self.ransackable_attributes(_auth_object = nil)
    %w[description correct]
  end

  private

  def only_correct_answer
    return unless correct

    question.answers.where(correct: true).update_all(correct: false)
  end
end
