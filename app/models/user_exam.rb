class UserExam < ApplicationRecord
  belongs_to :user
  belongs_to :exam
  has_many :user_answers, dependent: :destroy

  after_commit :set_exam_with_questions, on: :create
  before_validation :set_score, on: :create
  before_validation :record_exist, on: :create

  private

  def set_exam_with_questions
    GenerateExamParticipantJob.perform_later(self)
  end

  def record_exist
    errors.add(:user_exam, 'already exists') if UserExam.exists?(user:, exam:)
  end

  def set_score
    self.score ||= 0
  end
end
