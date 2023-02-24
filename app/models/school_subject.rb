class SchoolSubject < ApplicationRecord
  has_many :exams, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
end
