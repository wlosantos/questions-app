FactoryBot.define do
  factory :user_answer do
    user_exam
    question_ref { 1 }
    answer { 1 }
    trusty { false }
  end
end
