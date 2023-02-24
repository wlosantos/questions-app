class Answer < ApplicationRecord
  belongs_to :question

  validates :description, presence: true
  validates :correct, inclusion: { in: [true, false] }

  before_validation :only_correct_answer

  private

  def only_correct_answer
    return unless correct

    question.answers.where(correct: true).update_all(correct: false)
  end
end
