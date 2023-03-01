FactoryBot.define do
  factory :user_answer do
    user_exam
    quenstion_ref { user_exam.questions.first.id }
    answer { user_exam.questions.first.answers.first.id }
    trusty { false }
  end
end
