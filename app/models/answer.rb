class Answer < ApplicationRecord
  belongs_to :question

  validates :response, presence: true
  validates :corrected, inclusion: { in: [true, false] }

  before_validation :only_corrected_answer

  def self.ransackable_attributes(_auth_object = nil)
    %w[response corrected]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["question"]
  end

  private

  def only_corrected_answer
    return unless corrected

    question.answers.where(corrected: true).update_all(corrected: false)
  end
end
