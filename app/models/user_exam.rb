class UserExam < ApplicationRecord
  belongs_to :user
  belongs_to :exam
  has_many :user_answers, dependent: :destroy

  after_commit :set_exam_with_questions, on: :create
  before_validation :record_exist, on: :create

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  private

  def set_exam_with_questions
    GenerateExamParticipantJob.perform_later(self)
  end

  def record_exist
    errors.add(:user_exam, 'already exists') if UserExam.exists?(user:, exam:)
  end
end
