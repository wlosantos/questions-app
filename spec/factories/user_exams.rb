FactoryBot.define do
  factory :user_exam do
    score { 1.5 }
    user { nil }
    exam { nil }
  end
end
