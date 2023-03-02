class Subject < ApplicationRecord
  has_many :exams

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
end
