class UserAnswer < ApplicationRecord
  belongs_to :user_exam

  validates :question_ref, presence: true
  validates :answer, presence: true
  validate :question_exist?

  private

  def question_exist?
    errors.add(:question_ref, 'does not exist') unless Question.find_by(id: question_ref)
  end
end
