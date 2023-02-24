class Exam < ApplicationRecord
  belongs_to :school_subject
  belongs_to :user

  validates :title, presence: true
end
